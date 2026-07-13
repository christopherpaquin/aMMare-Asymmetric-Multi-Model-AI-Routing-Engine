#!/bin/bash
# scripts/validate-openhands.sh - Health check for OpenHands container

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/openhands.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/openhands.env
fi

PORT=${AMMARE_OPENHANDS_PORT:-3000}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying OpenHands home page at ${URL}...${NC}"

for i in {1..10}; do
    if curl -s -f "${URL}" > /dev/null; then
        echo -e "${GREEN}[PASS] OpenHands web interface responds successfully.${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for OpenHands (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] OpenHands health check failed.${NC}"
exit 1
