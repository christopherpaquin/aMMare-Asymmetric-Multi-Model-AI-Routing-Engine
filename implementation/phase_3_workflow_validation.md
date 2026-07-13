# **Phase 3: Direct Local Model Workflow Validation**

## **Objective**

Validate the minimal service chain consisting of `ammare-langchain` and `ammare-local-llm`. Ensure that the request path functions end-to-end, verify robust error handling during model endpoint restarts, and prove recovery.

---

## **Architecture Context**

This is the first end-to-end system integration validation. At this stage, the routing and optimization proxies (LiteLLM, Headroom) are omitted.

```text
[User / API Client]
        │ (HTTP POST /query to port 8080)
        ▼
[ammare-langchain]
        │ (Docker Bridge Network 'ammare-network')
        ▼
[ammare-local-llm:8000]
```

---

## **Required Files & Directories**

* [containers/local-llm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/local-llm/docker-compose.yaml) (Modified to attach to `ammare-network`)
* [scripts/validate-phase3-workflow.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-phase3-workflow.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Update local-llm Docker Compose Network Configuration**

To allow internal hostname lookup (`http://ammare-local-llm:8000`), we must update [containers/local-llm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/local-llm/docker-compose.yaml) to attach to the same `ammare-network` bridge as LangChain.

Update the `containers/local-llm/docker-compose.yaml` to include networks:

```yaml
version: '3.8'

services:
  ammare-local-llm:
    image: vllm/vllm-openai:latest
    container_name: ammare-local-llm
    restart: always
    ports:
      - "${AMMARE_LOCAL_LLM_PORT}:8000"
    environment:
      - HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN:-}
      - VLLM_USE_MODELSCOPE=False
    volumes:
      - "${AMMARE_LOCAL_LLM_CACHE_DIR}:/root/.cache/huggingface"
    ipc: host
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    networks:
      - ammare-network
    command: >
      --model ${AMMARE_LOCAL_LLM_MODEL_NAME}
      --tensor-parallel-size ${AMMARE_LOCAL_LLM_TENSOR_PARALLEL_SIZE}
      --max-model-len ${AMMARE_LOCAL_LLM_MAX_MODEL_LEN}
      --gpu-memory-utilization ${AMMARE_LOCAL_LLM_GPU_MEM_UTIL}
      --trust-remote-code

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 2: Re-deploy local-llm with network updates**

Rerun the deployment script to recreate the local LLM container within the shared network:

```bash
./scripts/deploy-local-llm.sh
```

### **Step 3: Create the Phase 3 Workflow Integration Script**

Create [scripts/validate-phase3-workflow.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-phase3-workflow.sh):

```bash
#!/bin/bash
# scripts/validate-phase3-workflow.sh - End-to-end integration and failure tests

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;0m'

LC_PORT=${AMMARE_LANGCHAIN_PORT:-8080}
LC_URL="http://localhost:${LC_PORT}"

echo -e "${BLUE}[INFO] Starting Phase 3 Integration Validation...${NC}"

# Test Case 1: Functional Request Path
echo -e "${BLUE}[INFO] Test Case 1: Verifying active inference path...${NC}"
TEST_QUERY="Identify this platform and respond with 'Hello aMMare'."
RESPONSE=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "'"${TEST_QUERY}"'"}')

if echo "$RESPONSE" | grep -iq "ammare"; then
    echo -e "${GREEN}[PASS] Test Case 1: Active request path validated.${NC}"
else
    echo -e "${RED}[FAIL] Test Case 1: Invalid response: $RESPONSE${NC}"
    exit 1
fi

# Test Case 2: Graceful Error Handling (Backend Down)
echo -e "${BLUE}[INFO] Test Case 2: Stopping local-llm endpoint to test failure mode...${NC}"
docker stop ammare-local-llm > /dev/null

echo -e "${BLUE}[INFO] Dispatching request with disabled model backend...${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "This query should fail gracefully."}')

if [ "$HTTP_STATUS" -eq 502 ]; then
    echo -e "${GREEN}[PASS] Test Case 2: Middleware returned correct gateway error (502).${NC}"
else
    echo -e "${RED}[FAIL] Test Case 2: Expected HTTP 502, got HTTP $HTTP_STATUS${NC}"
    # Make sure we start the container back up before failing out
    docker start ammare-local-llm > /dev/null
    exit 1
fi

# Test Case 3: Automatic Recovery
echo -e "${BLUE}[INFO] Test Case 3: Restarting ammare-local-llm container...${NC}"
docker start ammare-local-llm > /dev/null

echo -e "${BLUE}[INFO] Waiting for model to reload (this can take up to 2 minutes)...${NC}"
# Wait for backend to recover
./scripts/validate-local-llm.sh

echo -e "${BLUE}[INFO] Retrying integration query after backend recovery...${NC}"
RESPONSE_RETRY=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Verify system recovery and respond with '\''Recovered'\''. "}')

if echo "$RESPONSE_RETRY" | grep -iq "recovered"; then
    echo -e "${GREEN}[PASS] Test Case 3: Automatic recovery validated successfully!${NC}"
else
    echo -e "${RED}[FAIL] Test Case 3: Recovery validation failed. Output: $RESPONSE_RETRY${NC}"
    exit 1
fi

echo -e "${GREEN}[PASS] All Phase 3 Workflow Integration tests passed!${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/validate-phase3-workflow.sh
```

---

## **Validation & Success Criteria**

Execute the workflow integration validation script:

```bash
./scripts/validate-phase3-workflow.sh
```

### **Success Criteria**

* Normal requests flow from client through LangChain, execute chat completion on vLLM, and print the expected output.
* Stopping the local-llm container causes LangChain to return HTTP 502 and print a detailed log entry.
* Starting the local-llm container restores functional query paths automatically.

---

## **Troubleshooting**

* **Container Name Resolution Failure:** If LangChain logs output `Failed to resolve host ammare-local-llm`, double check that both containers are on `ammare-network` and verify using: `docker network inspect ammare-network`.
* **vLLM Cache Directory permissions:** If the local LLM container is restarted but crashes during startup, ensure the host directory specified in `AMMARE_LOCAL_LLM_CACHE_DIR` is writeable by the container.
