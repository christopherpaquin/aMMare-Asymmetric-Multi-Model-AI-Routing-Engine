# **Phase 5: Cloud Model Provider Integration**

## **Objective**

Integrate external cloud model providers (Anthropic Claude, OpenAI GPT, or Google Gemini) into the `ammare-litellm` router. Securely manage credentials using git-ignored configuration, and validate connection paths.

---

## **Architecture Context**

This adds high-capability cloud-hosted frontier model models as routing endpoints under LiteLLM.

```text
                     ┌───> [ammare-local-llm:8000]
[LiteLLM (4000)] ────┤
                     └───> [Frontier Cloud APIs (Claude / GPT-4 / Gemini)]
```

---

## **Required Files & Directories**

* [env/secrets.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/secrets.env.example)
* [config/litellm/config.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml) (Modified to register cloud models)
* [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml) (Modified to load secrets)
* [scripts/validate-cloud-connection.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-cloud-connection.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Scaffold env/secrets.env.example**

Create [env/secrets.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/secrets.env.example) to catalog external credentials:

```bash
# ==============================================================================
# aMMare Secrets Configuration Template - NEVER COMMIT ACTUAL KEYS TO GIT
# ==============================================================================

# Anthropic Claude API Key (for Claude 3.5 Sonnet)
ANTHROPIC_API_KEY=your-anthropic-api-key-here

# OpenAI API Key (for GPT-4o)
OPENAI_API_KEY=your-openai-api-key-here

# Google Gemini API Key
GEMINI_API_KEY=your-gemini-api-key-here
```

*Create the real secrets file (which is git-ignored):*

```bash
cp env/secrets.env.example env/secrets.env
```

### **Step 2: Update LiteLLM Configuration**

Modify [config/litellm/config.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml) to register cloud backends under predictable routing names:

```yaml
model_list:
  - model_name: local-coder
    litellm_params:
      model: openai/Qwen/Qwen2.5-Coder-7B-Instruct
      api_base: http://ammare-local-llm:8000/v1
      api_key: ignored-for-local
      tpm: 100000
      rpm: 1000

  - model_name: cloud-reasoner
    litellm_params:
      model: claude-3-5-sonnet-20241022
      api_key: os.environ/ANTHROPIC_API_KEY
      tpm: 80000
      rpm: 1000

  - model_name: cloud-fallback
    litellm_params:
      model: gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      tpm: 80000
      rpm: 1000

router_settings:
  routing_strategy: latency-based-routing
  enable_pre_call_checks: true

general_settings:
  master_key: sk-ammare-master-key-12345
  store_model_in_db: false
```

### **Step 3: Update LiteLLM Compose config**

Modify [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml) to load env files:

```yaml
version: '3.8'

services:
  ammare-litellm:
    image: ghcr.io/berriai/litellm:main-latest
    container_name: ammare-litellm
    restart: always
    ports:
      - "${AMMARE_LITELLM_PORT}:4000"
    env_file:
      - ../../env/litellm.env
      - ../../env/secrets.env
    volumes:
      - "${AMMARE_LITELLM_CONFIG_PATH}:/app/config.yaml"
    command: [ "--config", "/app/config.yaml", "--port", "4000" ]
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 4: Write Cloud Validation Script**

Create [scripts/validate-cloud-connection.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-cloud-connection.sh):

```bash
#!/bin/bash
# scripts/validate-cloud-connection.sh - Tests cloud route connectivity through LiteLLM

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_LITELLM_PORT:-4000}
URL="http://localhost:${PORT}/v1"
API_KEY=${LITELLM_MASTER_KEY:-sk-ammare-master-key-12345}

# Load secrets to check if they are set before testing
if [ -f env/secrets.env ]; then
    export $(grep -v '^#' env/secrets.env | xargs)
else
    echo -e "${RED}[FAIL] secrets.env not found. Please create it.${NC}"
    exit 1
fi

if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -z "${OPENAI_API_KEY:-}" ]; then
    echo -e "${RED}[FAIL] Both ANTHROPIC_API_KEY and OPENAI_API_KEY are empty. Cloud test skipped.${NC}"
    exit 1
fi

# Re-deploy LiteLLM proxy with the updated compose layout and secrets
echo -e "${BLUE}[INFO] Re-deploying LiteLLM with secrets...${NC}"
./scripts/deploy-litellm.sh
sleep 3

echo -e "${BLUE}[INFO] Querying cloud-reasoner route through LiteLLM...${NC}"

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "cloud-reasoner",
        "messages": [{"role": "user", "content": "Respond with the word: cloud-success."}],
        "max_tokens": 10
      }')

    if echo "$RESPONSE" | grep -q "cloud-success"; then
        echo -e "${GREEN}[PASS] Anthropic Claude route active through LiteLLM proxy!${NC}"
        exit 0
    else
        echo -e "${RED}[FAIL] Failed cloud connection to Anthropic Claude: $RESPONSE${NC}"
        exit 1
    fi
fi

if [ -n "${OPENAI_API_KEY:-}" ]; then
    RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "cloud-fallback",
        "messages": [{"role": "user", "content": "Respond with the word: cloud-success."}],
        "max_tokens": 10
      }')

    if echo "$RESPONSE" | grep -q "cloud-success"; then
        echo -e "${GREEN}[PASS] OpenAI GPT route active through LiteLLM proxy!${NC}"
        exit 0
    else
        echo -e "${RED}[FAIL] Failed cloud connection to OpenAI: $RESPONSE${NC}"
        exit 1
    fi
fi
```

Make executable:

```bash
chmod +x scripts/validate-cloud-connection.sh
```

---

## **Validation & Success Criteria**

1. Populate your keys inside `env/secrets.env`.
2. Run validation:

   ```bash
   ./scripts/validate-cloud-connection.sh
   ```

### **Success Criteria**

* LiteLLM container reloads successfully and consumes the keys from `env/secrets.env`.
* Querying `/chat/completions` for `cloud-reasoner` (or `cloud-fallback`) returns a valid completion and prints `[PASS]`.
* Under no circumstances are keys printed to standard output or cached inside logs.

---

## **Troubleshooting**

* **400 Bad Request / Invalid Key:** Double check API keys inside `env/secrets.env`. Verify there are no leading/trailing spaces or quotes.
* **Secrets committed to Git:** If `git status` shows `secrets.env` is tracked, run `git rm --cached env/secrets.env` immediately.
