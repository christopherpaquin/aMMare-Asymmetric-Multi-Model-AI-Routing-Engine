#!/bin/bash
# scripts/deploy-local-llm.sh - Deploys local model endpoint

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/local-llm.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/local-llm.env
else
    echo -e "${RED}[FAIL] local-llm.env not found in env/. Please copy env/local-llm.env.example to env/local-llm.env and customize.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Starting ammare-local-llm container...${NC}"
mkdir -p "${AMMARE_LOCAL_LLM_CACHE_DIR}"

export CUDA_VISIBLE_DEVICES="${AMMARE_LOCAL_LLM_GPU_DEVICES}"

# Ensure internal bridge network exists
docker network create ammare-network 2>/dev/null || true

docker compose -f containers/local-llm/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-local-llm service deployment initiated.${NC}"
exit 0
