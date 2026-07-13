# **Phase 7: Headroom Integration**

## **Objective**

Deploy a containerized `Headroom` proxy service on port `4100`. Configure it to receive requests from LangChain, optimize context tokens, route traffic upstream to `LiteLLM` (port `4000`), and implement config-driven bypass parameters.

---

## **Architecture Context**

Headroom acts as an inline token compression proxy. It sits between the orchestration layer (LangChain) and the model router (LiteLLM).

```text
[LangChain (8080)] ===> [Headroom Proxy (4100)] ===> [LiteLLM (4000)] ===> [Backends]
```

---

## **Required Files & Directories**

* [env/headroom.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/headroom.env.example)
* [config/headroom/config.json](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/headroom/config.json)
* [containers/headroom/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/headroom/docker-compose.yaml)
* [scripts/deploy-headroom.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-headroom.sh)
* [scripts/validate-headroom.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-headroom.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create Headroom Environment Template**

Create [env/headroom.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/headroom.env.example):

```bash
# ==============================================================================
# ammare-headroom Environment Configuration Template
# ==============================================================================

# Port Headroom listens on
AMMARE_HEADROOM_PORT=4100

# Upstream proxy endpoint (LiteLLM router url inside Docker network)
AMMARE_HEADROOM_UPSTREAM_URL=http://ammare-litellm:4000

# Headroom config file path
AMMARE_HEADROOM_CONFIG_PATH=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/headroom/config.json
```

### **Step 2: Create Headroom Config File**

Create [config/headroom/config.json](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/headroom/config.json) to set context optimization limits and formatting bypass triggers:

```json
{
  "upstream_url": "http://ammare-litellm:4000",
  "compression_rules": {
    "enabled": true,
    "strategy": "summary-and-truncate",
    "history_token_limit": 4096
  },
  "bypass_rules": {
    "enabled": true,
    "bypass_headers": ["X-AMMARE-BYPASS-COMPRESSION"],
    "bypass_keywords": ["diff", "patch", "git apply", "tool_call"]
  }
}
```

### **Step 3: Define Compose Stack**

Create [containers/headroom/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/headroom/docker-compose.yaml):

```yaml
version: '3.8'

services:
  ammare-headroom:
    image: headroomlabs/headroom-proxy:latest
    container_name: ammare-headroom
    restart: always
    ports:
      - "${AMMARE_HEADROOM_PORT}:4100"
    environment:
      - UPSTREAM_URL=${AMMARE_HEADROOM_UPSTREAM_URL}
    volumes:
      - "${AMMARE_HEADROOM_CONFIG_PATH}:/etc/headroom/config.json"
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 4: Create deployment and validation scripts**

Create [scripts/deploy-headroom.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-headroom.sh):

```bash
#!/bin/bash
# scripts/deploy-headroom.sh - Deploys Headroom proxy container

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/headroom.env ]; then
    export $(grep -v '^#' env/headroom.env | xargs)
else
    echo -e "${RED}[FAIL] headroom.env not found. Please copy env/headroom.env.example to env/headroom.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Starting ammare-headroom proxy container...${NC}"
docker compose -f containers/headroom/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-headroom deployment initiated.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy-headroom.sh
```

Create [scripts/validate-headroom.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-headroom.sh):

```bash
#!/bin/bash
# scripts/validate-headroom.sh - Verifies Headroom proxy status

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_HEADROOM_PORT:-4100}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Checking Headroom proxy status at ${URL}...${NC}"

for i in {1..10}; do
    # Verify TCP socket listener
    if curl -s -I "$URL" &> /dev/null || curl -s -f "$URL/health" &> /dev/null; then
        echo -e "${GREEN}[PASS] ammare-headroom proxy listener is active.${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for Headroom (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] Headroom proxy is not responding.${NC}"
exit 1
```

Make executable:

```bash
chmod +x scripts/validate-headroom.sh
```

### **Step 5: Repoint LangChain through Headroom**

1. Modify the logical endpoint inside [env/langchain.env](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/langchain.env) to route model traffic through Headroom instead of LiteLLM directly:

   ```bash
   AMMARE_MODEL_GATEWAY_URL=http://ammare-headroom:4100/v1
   ```

2. Re-deploy the LangChain middleware:

   ```bash
   ./scripts/deploy-langchain.sh
   ```

3. Run the integration test scripts to verify the complete communication chain is intact:

   ```bash
   ./scripts/validate-routing.sh
   ```

---

## **Validation & Success Criteria**

* Running `./scripts/validate-headroom.sh` returns success (`[PASS]`).
* Standard queries flow through LangChain -> Headroom -> LiteLLM -> Model, responding correctly.
* In situations where a payload containing code patches or "git apply" commands is dispatched, verify in the Headroom proxy logs that the bypass rules are activated and the formatting is passed downstream untouched.

---

## **Troubleshooting**

* **Connection Refused on 4100:** Check if port 4100 is already in use on the host machine. If it is, update `AMMARE_HEADROOM_PORT` in the env files and re-deploy.
* **Corrupt JSON Structure downstream:** If LiteLLM complains about malformed JSON payloads from Headroom, ensure that `bypass_rules` keywords are correctly configured or toggle compression `enabled: false` in `config/headroom/config.json` for troubleshooting.
