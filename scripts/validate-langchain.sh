#!/bin/bash
# scripts/validate-langchain.sh - Health check for langchain middleware

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
fi

PORT=${AMMARE_LANGCHAIN_PORT:-8080}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying ammare-langchain health checkpoint at ${URL}...${NC}"

for i in {1..10}; do
    if RESPONSE=$(curl -s -f "${URL}/health"); then
        echo -e "${GREEN}[PASS] ammare-langchain responds to health query.${NC}"
        echo -e "${BLUE}[INFO] Health Details: $RESPONSE${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for LangChain container (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] LangChain health check failed.${NC}"
exit 1
