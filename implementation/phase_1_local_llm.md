# **Phase 1: Local LLM Endpoint**

## **Objective**

Deploy a containerized local LLM inference endpoint using `vLLM` on dual NVIDIA RTX 3060 GPUs (24GB total VRAM) with tensor parallelism enabled. Ensure the API auto-starts on boot and provides an OpenAI-compatible endpoint.

---

## **Architecture Context**

The local model endpoint serves as the initial, default model in the aMMare physical service-chain. At this stage, LangChain will talk directly to this container.

```text
[User / Client] ===> [LangChain Agent Middleware] ===> [vLLM Endpoint (ammare-local-llm:8000)]
```

---

## **Required Files & Directories**

* [env/local-llm.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/local-llm.env.example)
* [containers/local-llm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/local-llm/docker-compose.yaml)
* [scripts/deploy-local-llm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-local-llm.sh)
* [scripts/validate-local-llm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-local-llm.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Define local-llm.env.example**

Create [env/local-llm.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/local-llm.env.example) to template configurations:

```bash
# ==============================================================================
# ammare-local-llm Environment Configuration Template
# ==============================================================================

# Port the local vLLM endpoint listens on
AMMARE_LOCAL_LLM_PORT=8000

# Path inside host where models are cached (to avoid redownloads)
AMMARE_LOCAL_LLM_CACHE_DIR=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/data/models

# Target model to download from Hugging Face
AMMARE_LOCAL_LLM_MODEL_NAME=Qwen/Qwen2.5-Coder-7B-Instruct

# GPU allocation and Tensor Parallelism (dual GPU requires size=2)
AMMARE_LOCAL_LLM_GPU_DEVICES="0,1"
AMMARE_LOCAL_LLM_TENSOR_PARALLEL_SIZE=2

# Maximum model context length
AMMARE_LOCAL_LLM_MAX_MODEL_LEN=8192

# GPU VRAM pre-allocation ratio (0.0 to 1.0)
AMMARE_LOCAL_LLM_GPU_MEM_UTIL=0.90
```

### **Step 2: Create local-llm Docker Compose configuration**

Create [containers/local-llm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/local-llm/docker-compose.yaml):

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
    command: >
      --model ${AMMARE_LOCAL_LLM_MODEL_NAME}
      --tensor-parallel-size ${AMMARE_LOCAL_LLM_TENSOR_PARALLEL_SIZE}
      --max-model-len ${AMMARE_LOCAL_LLM_MAX_MODEL_LEN}
      --gpu-memory-utilization ${AMMARE_LOCAL_LLM_GPU_MEM_UTIL}
      --trust-remote-code
```

### **Step 3: Write the Component Deploy Script**

Create [scripts/deploy-local-llm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-local-llm.sh):

```bash
#!/bin/bash
# scripts/deploy-local-llm.sh - Deploys local model endpoint

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/local-llm.env ]; then
    export $(grep -v '^#' env/local-llm.env | xargs)
else
    echo -e "${RED}[FAIL] local-llm.env not found in env/. Please copy env/local-llm.env.example to env/local-llm.env and customize.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Starting ammare-local-llm container...${NC}"
mkdir -p "${AMMARE_LOCAL_LLM_CACHE_DIR}"

export CUDA_VISIBLE_DEVICES="${AMMARE_LOCAL_LLM_GPU_DEVICES}"

docker compose -f containers/local-llm/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-local-llm service deployment initiated.${NC}"
exit 0
```

Make the script executable:

```bash
chmod +x scripts/deploy-local-llm.sh
```

### **Step 4: Write the Component Validation Script**

Create [scripts/validate-local-llm.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-local-llm.sh):

```bash
#!/bin/bash
# scripts/validate-local-llm.sh - Verifies the vLLM container is active and responding

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_LOCAL_LLM_PORT:-8000}
URL="http://localhost:${PORT}/v1"

echo -e "${BLUE}[INFO] Validating ammare-local-llm endpoint at ${URL}...${NC}"

# Loop to wait for vLLM container startup (up to 5 minutes)
for i in {1..30}; do
    if curl -s -f "${URL}/models" > /dev/null; then
        echo -e "${GREEN}[PASS] local-llm is active and model is loaded.${NC}"

        # Perform request validation (smoke test)
        RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
          -H "Content-Type: application/json" \
          -d '{
            "model": "'"${AMMARE_LOCAL_LLM_MODEL_NAME:-Qwen/Qwen2.5-Coder-7B-Instruct}"'",
            "messages": [{"role": "user", "content": "Respond with the word: success."}],
            "max_tokens": 10
          }')

        if echo "$RESPONSE" | grep -q "success"; then
            echo -e "${GREEN}[PASS] Chat completion test succeeded!${NC}"
            exit 0
        else
            echo -e "${RED}[FAIL] Received unexpected response: $RESPONSE${NC}"
            exit 1
        fi
    fi
    echo -e "${BLUE}[INFO] Waiting for model to load in vLLM (attempt $i/30)...${NC}"
    sleep 10
done

echo -e "${RED}[FAIL] Timeout waiting for local-llm to load.${NC}"
exit 1
```

Make the script executable:

```bash
chmod +x scripts/validate-local-llm.sh
```

---

## **Validation & Success Criteria**

Before proceeding:

1. Initialize your local configuration file:

   ```bash
   cp env/local-llm.env.example env/local-llm.env
   ```

2. Execute deployment:

   ```bash
   ./scripts/deploy-local-llm.sh
   ```

3. Run verification:

   ```bash
   ./scripts/validate-local-llm.sh
   ```

### **Success Criteria**

* Container starts, runs in background, and shows no restart loops.
* Container allocates CUDA devices and tensor parallelism scales to 2 GPUs.
* Curl verification outputs `[PASS] Chat completion test succeeded!`.

---

## **Troubleshooting**

* **Out Of Memory (OOM):** If vLLM crashes with a CUDA OOM error, reduce `AMMARE_LOCAL_LLM_GPU_MEM_UTIL` to `0.85` or decrease `AMMARE_LOCAL_LLM_MAX_MODEL_LEN`.
* **Failed to Initialize NVML:** Ensure `nvidia-container-toolkit` is configured, restart docker: `sudo systemctl restart docker`.
