# **Phase 0: Repository Scaffold and Baseline Standards**

## **Objective**

Establish a clean, consistent repository layout, baseline linting/formatting standards, git-ignore rules for secrets, and foundational operational scripts.

---

## **Architecture Context**

Before deploying any local container or middleware, we must scaffold the workspace directories and automate basic syntax and preflight checks to guarantee code quality and prevent credentials leak.

---

## **Required Files & Directories**

Ensure the following directory structure is created in the repository root:

* [config/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config) - Container config directories (`langchain/`, `litellm/`, etc.)
* [containers/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers) - Dockerfiles
* [env/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env) - `.env.example` templates
* [scripts/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts) - Operational and validation scripts
* [tests/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/tests) - Unit & integration tests
* [data/](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/data) - (Ignored) persistent storage

---

## **Step-by-Step Instructions**

### **Step 1: Configure Git Exclusions**

Update or create the [.gitignore](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/.gitignore) file in the root to ensure all runtime configuration, secrets, models, and data directory mounts are excluded:

```text
# Local Environment Overrides & Secrets
env/*.env
!env/*.env.example
secrets.env

# Build & Python caches
__pycache__/
*.pyc
.ruff_cache/
.pytest_cache/

# Runtime Data and Logs
data/
logs/
*.log
tmp/
```

### **Step 2: Define the Global Environment Template**

Create [env/ammare.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/ammare.env.example) to establish global configuration defaults:

```bash
# ==============================================================================
# aMMare Global Environment Configuration Template
# ==============================================================================

# Active deployment profile: minimal-local | hybrid | full
AMMARE_DEPLOY_PROFILE=minimal-local

# Core repository path pointers
AMMARE_BASE_DIR=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine
AMMARE_CONFIG_DIR=${AMMARE_BASE_DIR}/config
AMMARE_DATA_DIR=${AMMARE_BASE_DIR}/data
AMMARE_LOG_DIR=${AMMARE_BASE_DIR}/logs

# Logging Verbosity: DEBUG | INFO | WARNING | ERROR
AMMARE_LOG_LEVEL=INFO

# Feature Flags for Services
AMMARE_ENABLE_LITELLM=false
AMMARE_ENABLE_HEADROOM=false
AMMARE_ENABLE_OPENHANDS=false
AMMARE_ENABLE_MEMORY=false
```

### **Step 3: Create the Preflight Checks Script**

Create [scripts/preflight.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/preflight.sh) to validate host dependencies (Docker, NVIDIA Container Toolkit, directory presence):

```bash
#!/bin/bash
# scripts/preflight.sh - Host environment validation script

set -euo pipefail

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;0m'

echo -e "${BLUE}[INFO] Running Host Preflight Checks...${NC}"

# Check Docker Installation
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[FAIL] Docker is not installed or not in PATH.${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Docker is installed.${NC}"
fi

# Check Docker Compose (v2)
if ! docker compose version &> /dev/null; then
    echo -e "${RED}[FAIL] Docker Compose (v2) is not installed.${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Docker Compose is installed.${NC}"
fi

# Check NVIDIA GPU and Container Toolkit
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}[PASS] NVIDIA GPU found.${NC}"
    if docker run --help | grep -q -- "--gpus"; then
        echo -e "${GREEN}[PASS] NVIDIA Container Toolkit integrated with Docker.${NC}"
    else
        echo -e "${YELLOW}[WARN] NVIDIA GPUs found but Docker --gpus option not verified.${NC}"
    fi
else
    echo -e "${YELLOW}[WARN] No NVIDIA GPU found on this system. GPU-enabled containers may fail.${NC}"
fi

# Validate project directory structure
REQUIRED_DIRS=("config" "containers" "env" "scripts" "tests")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}[PASS] Directory '${dir}/' exists.${NC}"
    else
        echo -e "${RED}[FAIL] Required directory '${dir}/' is missing.${NC}"
        exit 1
    fi
done

echo -e "${GREEN}[PASS] Preflight checks passed successfully!${NC}"
exit 0
```

Make the script executable:

```bash
chmod +x scripts/preflight.sh
```

---

## **Validation & Success Criteria**

To validate Phase 0, run the preflight script:

```bash
./scripts/preflight.sh
```

### **Success Criteria**

* The output prints `[PASS]` for all directory checks.
* Docker and Docker Compose are verified.
* No `.env` files are tracked in git (run `git status` to verify).

---

## **Troubleshooting**

* **NVIDIA Toolkit Warning:** If the script prints `[WARN] No NVIDIA GPU found`, ensure drivers are installed and that `nvidia-container-toolkit` is configured correctly in `/etc/docker/daemon.json` if running on a GPU-enabled host.
