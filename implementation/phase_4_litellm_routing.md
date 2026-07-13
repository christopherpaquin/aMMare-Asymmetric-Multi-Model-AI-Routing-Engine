# **Phase 4: LiteLLM Routing Layer**

## **Objective**

Deploy a containerized `LiteLLM` instance exposing port `4000`. Configure it to proxy requests to the local `ammare-local-llm` model endpoint, issue client virtual keys, and update the LangChain middleware configuration to route model requests through LiteLLM.

---

## **Architecture Context**

LiteLLM becomes the unified model routing gateway. It isolates LangChain from direct dependencies on backend model structures.

```text
[User / API Client] ===> [LangChain (8080)] ===> [LiteLLM (4000)] ===> [vLLM Endpoint (8000)]
```

---

## **Required Files & Directories**

* [env/litellm.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/litellm.env.example)
* [config/litellm/config.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml)
* [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml)
* [scripts/deploy-litellm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-litellm.sh)
* [scripts/validate-litellm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-litellm.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create environment template**

Create [env/litellm.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/litellm.env.example):

```bash
# ==============================================================================
# ammare-litellm Environment Configuration Template
# ==============================================================================

# Port LiteLLM listens on
AMMARE_LITELLM_PORT=4000

# Path to the LiteLLM model routing configuration file
AMMARE_LITELLM_CONFIG_PATH=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml

# Master API Key for administration
LITELLM_MASTER_KEY=sk-ammare-master-key-12345
```

### **Step 2: Create LiteLLM config yaml**

Create [config/litellm/config.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml):

```yaml
model_list:
  - model_name: local-coder
    litellm_params:
      model: openai/Qwen/Qwen2.5-Coder-7B-Instruct
      api_base: http://ammare-local-llm:8000/v1
      api_key: ignored-for-local
      tpm: 100000
      rpm: 1000

router_settings:
  routing_strategy: latency-based-routing
  enable_pre_call_checks: true

general_settings:
  master_key: sk-ammare-master-key-12345
  store_model_in_db: false
```

### **Step 3: Define Compose Stack**

Create [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml):

```yaml
version: '3.8'

services:
  ammare-litellm:
    image: ghcr.io/berriai/litellm:main-latest
    container_name: ammare-litellm
    restart: always
    ports:
      - "${AMMARE_LITELLM_PORT}:4000"
    environment:
      - LITELLM_MASTER_KEY=${LITELLM_MASTER_KEY}
    volumes:
      - "${AMMARE_LITELLM_CONFIG_PATH}:/app/config.yaml"
    command: [ "--config", "/app/config.yaml", "--port", "4000", "--detailed_debug" ]
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 4: Create deployment and validation scripts**

Create [scripts/deploy-litellm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-litellm.sh):

```bash
#!/bin/bash
# scripts/deploy-litellm.sh - Deploys LiteLLM proxy

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/litellm.env ]; then
    export $(grep -v '^#' env/litellm.env | xargs)
else
    echo -e "${RED}[FAIL] litellm.env not found. Please copy env/litellm.env.example to env/litellm.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Starting ammare-litellm proxy container...${NC}"
docker compose -f containers/litellm/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-litellm deployment initiated.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy-litellm.sh
```

Create [scripts/validate-litellm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-litellm.sh):

```bash
#!/bin/bash
# scripts/validate-litellm.sh - Verifies LiteLLM routing and connectivity

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_LITELLM_PORT:-4000}
URL="http://localhost:${PORT}"
API_KEY=${LITELLM_MASTER_KEY:-sk-ammare-master-key-12345}

echo -e "${BLUE}[INFO] Testing LiteLLM model routing connectivity at ${URL}...${NC}"

# Check endpoint health
for i in {1..10}; do
    if curl -s -f "${URL}/health/services" -H "Authorization: Bearer $API_KEY" > /dev/null; then
        echo -e "${GREEN}[PASS] LiteLLM health API responded.${NC}"

        # Test routing query to local-coder alias
        RESPONSE=$(curl -s -X POST "${URL}/v1/chat/completions" \
          -H "Content-Type: application/json" \
          -H "Authorization: Bearer $API_KEY" \
          -d '{
            "model": "local-coder",
            "messages": [{"role": "user", "content": "Respond with the word: proxy success."}],
            "max_tokens": 10
          }')

        if echo "$RESPONSE" | grep -q "proxy success"; then
            echo -e "${GREEN}[PASS] LiteLLM chat completions routed through to local model successfully!${NC}"
            exit 0
        else
            echo -e "${RED}[FAIL] Unexpected response through proxy: $RESPONSE${NC}"
            exit 1
        fi
    fi
    echo -e "${BLUE}[INFO] Waiting for LiteLLM (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] LiteLLM proxy failed to establish model route.${NC}"
exit 1
```

Make executable:

```bash
chmod +x scripts/validate-litellm.sh
```

### **Step 5: Repoint LangChain Middleware**

Once the LiteLLM container has been validated:

1. Update [env/langchain.env](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/langchain.env) to repoint the gateway to LiteLLM:

   ```bash
   AMMARE_MODEL_GATEWAY_URL=http://ammare-litellm:4000/v1
   AMMARE_LANGCHAIN_MODEL_NAME=local-coder
   ```

2. Set API keys for the model backend in `env/langchain.env` if required (e.g. `OPENAI_API_KEY=sk-ammare-master-key-12345` to authenticate against LiteLLM).
3. Restart `ammare-langchain`:

   ```bash
   ./scripts/deploy-langchain.sh
   ```

4. Run validation:

   ```bash
   ./scripts/validate-langchain.sh
   ```

---

## **Validation & Success Criteria**

* Execution of `./scripts/validate-litellm.sh` outputs `[PASS]`.
* Running `./scripts/validate-langchain.sh` completes successfully.
* Interrogating `http://localhost:8080/query` routes requests through `ammare-litellm` and returns correct answers. Check `docker logs ammare-litellm` to confirm traffic is logged.

---

## **Troubleshooting**

* **Authorization / Key mismatches:** If LiteLLM returns `HTTP 401 Unauthorized`, confirm that the `LITELLM_MASTER_KEY` defined in `env/litellm.env` matches the authentication bearer token header sent by client applications.
