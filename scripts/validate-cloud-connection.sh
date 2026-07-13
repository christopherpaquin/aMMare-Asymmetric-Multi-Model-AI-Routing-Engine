#!/bin/bash
# scripts/validate-cloud-connection.sh - Tests cloud route connectivity through LiteLLM

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0;0m'

PORT=${AMMARE_LITELLM_PORT:-4000}
URL="http://localhost:${PORT}/v1"
API_KEY=${LITELLM_MASTER_KEY:-sk-ammare-master-key-12345}

# Load secrets to check if they are set before testing
if [ -f env/secrets.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/secrets.env
fi

if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -z "${OPENAI_API_KEY:-}" ]; then
    echo -e "${YELLOW}[SKIP] Both ANTHROPIC_API_KEY and OPENAI_API_KEY are empty. Cloud test skipped.${NC}"
    exit 0
fi

echo -e "${BLUE}[INFO] Querying cloud-reasoner route through LiteLLM...${NC}"

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "cloud-reasoner",
        "messages": [{"role": "user", "content": "Respond with the word: cloud-success."}],
        "max_tokens": 10
      }')

    if echo "$RESPONSE" | grep -q "cloud-success"; then
        echo -e "${GREEN}[PASS] Anthropic Claude route active through LiteLLM proxy!${NC}"
        exit 0
    else
        echo -e "${RED}[FAIL] Failed cloud connection to Anthropic Claude: $RESPONSE${NC}"
        exit 1
    fi
fi

if [ -n "${OPENAI_API_KEY:-}" ]; then
    RESPONSE=$(curl -s -X POST "${URL}/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "cloud-fallback",
        "messages": [{"role": "user", "content": "Respond with the word: cloud-success."}],
        "max_tokens": 10
      }')

    if echo "$RESPONSE" | grep -q "cloud-success"; then
        echo -e "${GREEN}[PASS] OpenAI GPT route active through LiteLLM proxy!${NC}"
        exit 0
    else
        echo -e "${RED}[FAIL] Failed cloud connection to OpenAI: $RESPONSE${NC}"
        exit 1
    fi
fi
