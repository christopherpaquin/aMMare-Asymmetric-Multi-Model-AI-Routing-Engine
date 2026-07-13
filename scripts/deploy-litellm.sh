#!/bin/bash
# scripts/deploy-litellm.sh - Deploys LiteLLM proxy

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/litellm.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/litellm.env
else
    echo -e "${RED}[FAIL] litellm.env not found. Please copy env/litellm.env.example to env/litellm.env.${NC}"
    exit 1
fi

# Ensure secrets.env exists (even if empty) to prevent docker compose from complaining
touch env/secrets.env

echo -e "${BLUE}[INFO] Starting ammare-litellm proxy container...${NC}"

# Ensure internal bridge network exists
docker network create ammare-network 2>/dev/null || true

docker compose -f containers/litellm/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-litellm deployment initiated.${NC}"
exit 0
