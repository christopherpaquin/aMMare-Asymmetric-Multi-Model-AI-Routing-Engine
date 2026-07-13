#!/bin/bash
# scripts/validate-local-llm.sh - Verifies the vLLM container is active and responding

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
fi

PORT=${AMMARE_LOCAL_LLM_PORT:-8000}
URL="http://localhost:${PORT}/v1"
MODEL_NAME=${AMMARE_LOCAL_LLM_MODEL_NAME:-Qwen/Qwen2.5-Coder-7B-Instruct}

echo -e "${BLUE}[INFO] Validating ammare-local-llm endpoint at ${URL} (Model: ${MODEL_NAME})...${NC}"

# Loop to wait for vLLM container startup (up to 5 minutes)
for i in {1..30}; do
    if curl -s -f "${URL}/models" > /dev/null; then
        echo -e "${GREEN}[PASS] local-llm is active and model is loaded.${NC}"

        # Perform request validation (smoke test)
        RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
          -H "Content-Type: application/json" \
          -d '{
            "model": "'"${MODEL_NAME}"'",
            "messages": [{"role": "user", "content": "Respond with the word: success."}],
            "max_tokens": 10
          }')

        if echo "$RESPONSE" | grep -q "success"; then
            echo -e "${GREEN}[PASS] Chat completion test succeeded!${NC}"
            exit 0
        else
            echo -e "${RED}[FAIL] Received unexpected response: $RESPONSE${NC}"
            exit 1
        fi
    fi
    echo -e "${BLUE}[INFO] Waiting for model to load in vLLM (attempt $i/30)...${NC}"
    sleep 10
done

echo -e "${RED}[FAIL] Timeout waiting for local-llm to load.${NC}"
exit 1
