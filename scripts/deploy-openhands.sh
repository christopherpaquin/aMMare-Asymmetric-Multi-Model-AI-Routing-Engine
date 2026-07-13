#!/bin/bash
# scripts/deploy-openhands.sh - Deploys OpenHands agent environment

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/openhands.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/openhands.env
else
    echo -e "${RED}[FAIL] openhands.env not found. Please copy env/openhands.env.example to env/openhands.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Creating workspace base directory at ${AMMARE_WORKSPACE_BASE}...${NC}"
mkdir -p "$AMMARE_WORKSPACE_BASE"

echo -e "${BLUE}[INFO] Deploying ammare-openhands...${NC}"

# Ensure network exists
docker network create ammare-network 2>/dev/null || true

docker compose -f containers/openhands/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-openhands deployment initiated.${NC}"
exit 0
