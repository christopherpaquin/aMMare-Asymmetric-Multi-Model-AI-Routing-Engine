#!/bin/bash
# scripts/validate-memory.sh - Health check for Qdrant vector database

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/qdrant.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/qdrant.env
fi

PORT=${AMMARE_QDRANT_PORT:-6333}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying Qdrant collections at ${URL}...${NC}"

for i in {1..10}; do
    if RESPONSE=$(curl -s -f "${URL}/collections"); then
        echo -e "${GREEN}[PASS] Qdrant database responds successfully.${NC}"
        echo -e "${BLUE}[INFO] Collections info: $RESPONSE${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for Qdrant (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] Qdrant health check failed.${NC}"
exit 1
