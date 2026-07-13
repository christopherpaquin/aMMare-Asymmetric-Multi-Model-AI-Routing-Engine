# **Phase 11: One-Click Modular Deployment**

## **Objective**

Create top-level deployment, uninstallation, and validation orchestrator scripts in `scripts/`. Support multiple modular profiles (`minimal-local`, `hybrid`, `full`) configuration via CLI flags or environment variables, ensuring all operations are idempotent.

---

## **Architecture Context**

The top-level orchestrators compile individual component deployment routines into a single automated pipeline.

```text
               ┌──> deploy-local-llm.sh
               ├──> deploy-langchain.sh
[deploy.sh] ───┼──> deploy-litellm.sh
               ├──> deploy-headroom.sh
               └──> ...
```

---

## **Required Files & Directories**

* [scripts/deploy.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy.sh)
* [scripts/uninstall.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/uninstall.sh)
* [scripts/validate.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Write the Top-Level Deploy Script**

Create [scripts/deploy.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy.sh):

```bash
#!/bin/bash
# scripts/deploy.sh - Orchestrates deployment of the aMMare platform components

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source global env
if [ -f env/ammare.env ]; then
    export $(grep -v '^#' env/ammare.env | xargs)
else
    echo -e "${BLUE}[INFO] env/ammare.env not found. Copying defaults...${NC}"
    cp env/ammare.env.example env/ammare.env
    export $(grep -v '^#' env/ammare.env | xargs)
fi

PROFILE=${AMMARE_DEPLOY_PROFILE:-minimal-local}

# Parse optional command line flags
while getopts "p:" opt; do
  case $opt in
    p) PROFILE="$OPTARG" ;;
    *) echo "Usage: $0 [-p profile]"; exit 1 ;;
  esac
done

echo -e "${BLUE}[INFO] Executing deployment orchestrator for profile: '${PROFILE}'${NC}"

# Ensure shared bridge network exists
docker network create ammare-network 2>/dev/null || true

# Helper function to instantiate component env files if missing
init_env() {
  local comp=$1
  if [ ! -f "env/${comp}.env" ]; then
    echo -e "${BLUE}[INFO] Copying template: env/${comp}.env.example -> env/${comp}.env${NC}"
    cp "env/${comp}.env.example" "env/${comp}.env"
  fi
}

case $PROFILE in
  "minimal-local")
    init_env "local-llm"
    init_env "langchain"
    # Wire LangChain directly to local LLM for minimal setup
    sed -i 's|AMMARE_MODEL_GATEWAY_URL=.*|AMMARE_MODEL_GATEWAY_URL=http://ammare-local-llm:8000/v1|g' env/langchain.env

    ./scripts/deploy-local-llm.sh
    ./scripts/deploy-langchain.sh
    ;;

  "hybrid")
    init_env "local-llm"
    init_env "litellm"
    init_env "langchain"
    # Wire LangChain to LiteLLM router
    sed -i 's|AMMARE_MODEL_GATEWAY_URL=.*|AMMARE_MODEL_GATEWAY_URL=http://ammare-litellm:4000/v1|g' env/langchain.env

    ./scripts/deploy-local-llm.sh
    ./scripts/deploy-litellm.sh
    ./scripts/deploy-langchain.sh
    ;;

  "full")
    init_env "local-llm"
    init_env "litellm"
    init_env "headroom"
    init_env "openhands"
    init_env "memory"
    init_env "langchain"
    # Wire LangChain to Headroom proxy
    sed -i 's|AMMARE_MODEL_GATEWAY_URL=.*|AMMARE_MODEL_GATEWAY_URL=http://ammare-headroom:4100/v1|g' env/langchain.env

    ./scripts/deploy-local-llm.sh
    ./scripts/deploy-litellm.sh
    ./scripts/deploy-headroom.sh
    ./scripts/deploy-memory.sh
    ./scripts/deploy-openhands.sh
    ./scripts/deploy-langchain.sh
    ;;

  *)
    echo -e "${RED}[FAIL] Unknown deployment profile: $PROFILE${NC}"
    exit 1
    ;;
esac

echo -e "${GREEN}[PASS] aMMare stack deployment orchestrations completed successfully!${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy.sh
```

### **Step 2: Write the Uninstall/Reset Script**

Create [scripts/uninstall.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/uninstall.sh):

```bash
#!/bin/bash
# scripts/uninstall.sh - Stops containers, tears down networks, and optionally purges cache files

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PURGE_MODELS=false

while getopts "x" opt; do
  case $opt in
    x) PURGE_MODELS=true ;;
    *) echo "Usage: $0 [-x (purge models)]"; exit 1 ;;
  esac
done

echo -e "${BLUE}[INFO] Initiating aMMare platform teardown...${NC}"

# Tear down Docker Compose stacks
docker compose -f containers/langchain/docker-compose.yaml down || true
docker compose -f containers/litellm/docker-compose.yaml down || true
docker compose -f containers/headroom/docker-compose.yaml down || true
docker compose -f containers/qdrant/docker-compose.yaml down || true
docker compose -f containers/openhands/docker-compose.yaml down || true
docker compose -f containers/local-llm/docker-compose.yaml down || true

# Remove network
docker network rm ammare-network 2>/dev/null || true

# Clear temporary logs and configurations
rm -rf tmp/* logs/*.log 2>/dev/null || true

# Purge indexed models if requested
if [ "$PURGE_MODELS" = true ]; then
  echo -e "${RED}[WARNING] Purging HuggingFace cache models and vector DB data...${NC}"
  rm -rf data/* 2>/dev/null || true
fi

echo -e "${GREEN}[PASS] Teardown clean and complete.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/uninstall.sh
```

### **Step 3: Write the Validation Orchestrator**

Create [scripts/validate.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate.sh):

```bash
#!/bin/bash
# scripts/validate.sh - Unified validation entry-point detecting active profile

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source active profile
if [ -f env/ammare.env ]; then
    export $(grep -v '^#' env/ammare.env | xargs)
fi
PROFILE=${AMMARE_DEPLOY_PROFILE:-minimal-local}

echo -e "${BLUE}[INFO] Executing validations for profile: '${PROFILE}'${NC}"

case $PROFILE in
  "minimal-local")
    ./scripts/validate-local-llm.sh
    ./scripts/validate-langchain.sh
    ./scripts/validate-phase3-workflow.sh
    ;;
  "hybrid")
    ./scripts/validate-local-llm.sh
    ./scripts/validate-litellm.sh
    ./scripts/validate-langchain.sh
    ./scripts/validate-routing.sh
    ;;
  "full")
    ./scripts/validate-local-llm.sh
    ./scripts/validate-litellm.sh
    ./scripts/validate-headroom.sh
    ./scripts/validate-memory.sh
    ./scripts/validate-openhands.sh
    ./scripts/validate-full-chain.sh
    ;;
esac

echo -e "${GREEN}[PASS] Validations for profile '${PROFILE}' complete!${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/validate.sh
```

---

## **Validation & Success Criteria**

1. Clean your workspace:

   ```bash
   ./scripts/uninstall.sh -x
   ```

2. Run deployment using profile flags:

   ```bash
   ./scripts/deploy.sh -p minimal-local
   ```

3. Verify status:

   ```bash
   ./scripts/validate.sh
   ```

### **Success Criteria**

* Running `deploy.sh` installs only the components aligned with the selected profile.
* Running `validate.sh` detects the profile and triggers only corresponding tests.
* `uninstall.sh` safely stops all containers and cleans network links.
