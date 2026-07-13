#!/bin/bash
# scripts/deploy-langchain.sh - Deploys LangChain container middleware

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/langchain.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/langchain.env
else
    echo -e "${RED}[FAIL] langchain.env not found. Please copy env/langchain.env.example to env/langchain.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Creating ammare-network bridge network if missing...${NC}"
docker network create ammare-network 2>/dev/null || true

echo -e "${BLUE}[INFO] Building and starting ammare-langchain middleware...${NC}"
docker compose -f containers/langchain/docker-compose.yaml up -d --build

echo -e "${GREEN}[PASS] ammare-langchain deployment initiated.${NC}"
exit 0
