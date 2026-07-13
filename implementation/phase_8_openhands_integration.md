# **Phase 8: OpenHands Integration**

## **Objective**

Deploy the `ammare-openhands` workspace container, establishing secure directory mounts and user permission mappings. Issue a dedicated virtual key under LiteLLM for OpenHands and configure OpenHands to utilize the LiteLLM routing proxy.

---

## **Architecture Context**

OpenHands serves as the autonomous coding agent environment. It consumes LLMs directly through LiteLLM and operates on host-mounted git directories.

```text
[Browser User] ===> [OpenHands UI (Port 3000)]
                           │
                           ▼ (Requests LLM completions)
                     [LiteLLM (Port 4000)]
```

---

## **Required Files & Directories**

* [env/openhands.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/openhands.env.example)
* [containers/openhands/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/openhands/docker-compose.yaml)
* [scripts/deploy-openhands.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-openhands.sh)
* [scripts/validate-openhands.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-openhands.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create the OpenHands Env Template**

Create [env/openhands.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/openhands.env.example):

```bash
# ==============================================================================
# ammare-openhands Environment Configuration Template
# ==============================================================================

# User ID and Group ID matching the host developer user (prevents permission issues on files)
AMMARE_OPENHANDS_UID=1000
AMMARE_OPENHANDS_GID=1000

# Port OpenHands UI listens on
AMMARE_OPENHANDS_PORT=3000

# Directory containing projects that OpenHands is allowed to inspect/edit
AMMARE_OPENHANDS_WORKSPACE_DIR=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/data/openhands-workspaces

# OpenHands authentication key to communicate with LiteLLM
OPENHANDS_LLM_API_KEY=sk-ammare-openhands-key-56789
```

### **Step 2: Generate Virtual Key in LiteLLM config**

Update [config/litellm/config.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/litellm/config.yaml) to accept the virtual key for OpenHands:

```yaml
# Append to the end of config/litellm/config.yaml
# (In a production environment, LiteLLM keys would be managed in a database;
# for this POC, we register it as an allowed virtual key in the config or as an alternative credential)
```

*(Alternatively, because LiteLLM uses `master_key`, we can set `OPENHANDS_LLM_API_KEY` to equal the `LITELLM_MASTER_KEY` to simplify the token pipeline.)*

### **Step 3: Define Compose Stack**

Create [containers/openhands/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/openhands/docker-compose.yaml):

```yaml
version: '3.8'

services:
  ammare-openhands:
    image: ghcr.io/all-in-a-day-s-work/openhands:0.9 # Or stable equivalent
    container_name: ammare-openhands
    restart: always
    ports:
      - "${AMMARE_OPENHANDS_PORT}:3000"
    environment:
      - SANDBOX_USER_ID=${AMMARE_OPENHANDS_UID}
      - SANDBOX_GROUP_ID=${AMMARE_OPENHANDS_GID}
      - LLM_API_KEY=${OPENHANDS_LLM_API_KEY}
      - LLM_BASE_URL=http://ammare-litellm:4000/v1
      - LLM_MODEL=local-coder
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${AMMARE_OPENHANDS_WORKSPACE_DIR}:/workspace
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 4: Create deployment and validation scripts**

Create [scripts/deploy-openhands.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-openhands.sh):

```bash
#!/bin/bash
# scripts/deploy-openhands.sh - Deploys OpenHands workspace container

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/openhands.env ]; then
    export $(grep -v '^#' env/openhands.env | xargs)
else
    echo -e "${RED}[FAIL] openhands.env not found. Please copy env/openhands.env.example to env/openhands.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Constructing OpenHands workspace mounts...${NC}"
mkdir -p "${AMMARE_OPENHANDS_WORKSPACE_DIR}"

echo -e "${BLUE}[INFO] Starting ammare-openhands container...${NC}"
docker compose -f containers/openhands/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-openhands deployment initiated.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy-openhands.sh
```

Create [scripts/validate-openhands.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-openhands.sh):

```bash
#!/bin/bash
# scripts/validate-openhands.sh - Verifies OpenHands container status

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_OPENHANDS_PORT:-3000}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying OpenHands endpoint at ${URL}...${NC}"

for i in {1..15}; do
    if curl -s -f "$URL" > /dev/null; then
        echo -e "${GREEN}[PASS] ammare-openhands web server is running and healthy.${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for OpenHands container startup (attempt $i/15)...${NC}"
    sleep 5
done

echo -e "${RED}[FAIL] OpenHands server failed to respond.${NC}"
exit 1
```

Make executable:

```bash
chmod +x scripts/validate-openhands.sh
```

---

## **Validation & Success Criteria**

1. Copy configuration file:

   ```bash
   cp env/openhands.env.example env/openhands.env
   ```

2. Execute deployment:

   ```bash
   ./scripts/deploy-openhands.sh
   ```

3. Run verification:

   ```bash
   ./scripts/validate-openhands.sh
   ```

### **Success Criteria**

* OpenHands starts and logs no connection errors to Docker daemon.
* The browser console or UI is reachable at `http://localhost:3000`.
* OpenHands can successfully call LLM completions through LiteLLM.

---

## **Troubleshooting**

* **Docker Socket Permission Denied:** Ensure your host user belongs to the `docker` group (`sudo usermod -aG docker $USER` and log back in). The container requires access to `/var/run/docker.sock` to spin up sandbox container instances.
* **Workspace file permissions:** If OpenHands cannot edit files, verify that `AMMARE_OPENHANDS_UID` and `AMMARE_OPENHANDS_GID` match the output of running `id -u` and `id -g` on the host machine.
