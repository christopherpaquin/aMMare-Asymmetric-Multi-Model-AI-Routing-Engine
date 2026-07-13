#!/bin/bash
# scripts/deploy-headroom.sh - Deploys Headroom resource daemon

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/headroom.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/headroom.env
else
    echo -e "${RED}[FAIL] headroom.env not found. Please copy env/headroom.env.example to env/headroom.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Deploying ammare-headroom daemon...${NC}"

# Ensure network exists
docker network create ammare-network 2>/dev/null || true

docker compose -f containers/headroom/docker-compose.yaml up -d --build

echo -e "${GREEN}[PASS] ammare-headroom deployment initiated.${NC}"
exit 0
