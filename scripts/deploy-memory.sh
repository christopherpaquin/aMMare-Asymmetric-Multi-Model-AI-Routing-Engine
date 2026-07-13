#!/bin/bash
# scripts/deploy-memory.sh - Deploys Qdrant vector database

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/qdrant.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/qdrant.env
else
    echo -e "${RED}[FAIL] qdrant.env not found. Please copy env/qdrant.env.example to env/qdrant.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Deploying ammare-qdrant vector database...${NC}"

# Ensure network exists
docker network create ammare-network 2>/dev/null || true

docker compose -f containers/qdrant/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-qdrant deployment initiated.${NC}"
exit 0
