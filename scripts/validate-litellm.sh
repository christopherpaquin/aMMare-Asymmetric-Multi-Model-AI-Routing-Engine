#!/bin/bash
# scripts/validate-litellm.sh - Verifies LiteLLM routing and connectivity

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/litellm.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/litellm.env
fi

PORT=${AMMARE_LITELLM_PORT:-4000}
URL="http://localhost:${PORT}"
API_KEY=${LITELLM_MASTER_KEY:-sk-ammare-master-key-12345}

echo -e "${BLUE}[INFO] Testing LiteLLM model routing connectivity at ${URL}...${NC}"

# Check endpoint health
for i in {1..10}; do
    if curl -s -f "${URL}/health" -H "Authorization: Bearer $API_KEY" > /dev/null; then
        echo -e "${GREEN}[PASS] LiteLLM health API responded.${NC}"

        # Test routing query to local-coder alias
        RESPONSE=$(curl -s -X POST "${URL}/v1/chat/completions" \
          -H "Content-Type: application/json" \
          -H "Authorization: Bearer $API_KEY" \
          -d '{
            "model": "local-coder",
            "messages": [{"role": "user", "content": "Respond with the word: proxy success."}],
            "max_tokens": 10
          }')

        if echo "$RESPONSE" | grep -iq "proxy success"; then
            echo -e "${GREEN}[PASS] LiteLLM chat completions routed through to local model successfully!${NC}"
            exit 0
        else
            echo -e "${RED}[FAIL] Unexpected response through proxy: $RESPONSE${NC}"
            exit 1
        fi
    fi
    echo -e "${BLUE}[INFO] Waiting for LiteLLM (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] LiteLLM proxy failed to establish model route.${NC}"
exit 1
