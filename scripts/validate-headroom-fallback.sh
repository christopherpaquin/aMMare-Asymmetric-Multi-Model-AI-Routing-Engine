#!/bin/bash
# scripts/validate-headroom-fallback.sh - Validates headroom-triggered cloud fallback

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

LC_PORT=${AMMARE_LANGCHAIN_PORT:-8080}
LC_URL="http://localhost:${LC_PORT}"
HR_PORT=8001
HR_URL="http://localhost:${HR_PORT}"

echo -e "${BLUE}[INFO] Starting Headroom-Triggered Fallback Validation...${NC}"

# Test Case 1: Standard nominal VRAM routing (should route to local-coder)
echo -e "${BLUE}[INFO] Test Case 1: Simulating nominal VRAM (15% headroom) and querying standard prompt...${NC}"
curl -s -X POST "${HR_URL}/simulate-oom" \
  -H "Content-Type: application/json" \
  -d '{"headroom_percent": 15.0}' > /dev/null

RESPONSE_NOMINAL=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Say hello."}')

if echo "$RESPONSE_NOMINAL" | grep -q "local-coder"; then
    echo -e "${GREEN}[PASS] Standard query successfully routed to local-coder under nominal VRAM.${NC}"
else
    echo -e "${RED}[FAIL] Expected route to local-coder, got: $RESPONSE_NOMINAL${NC}"
    exit 1
fi

# Test Case 2: Simulate low VRAM headroom (should trigger fallback to cloud-reasoner)
echo -e "${BLUE}[INFO] Test Case 2: Simulating low VRAM (5% headroom)...${NC}"
curl -s -X POST "${HR_URL}/simulate-oom" \
  -H "Content-Type: application/json" \
  -d '{"headroom_percent": 5.0}' > /dev/null

echo -e "${BLUE}[INFO] Dispatching prompt under low VRAM conditions...${NC}"
# Since cloud keys are empty, this escalation should fail with HTTP 502
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Say hello."}')

if [ "$HTTP_STATUS" -eq 502 ]; then
    echo -e "${GREEN}[PASS] Low VRAM correctly triggered escalation to cloud models, resulting in expected HTTP 502 fallback exhaustion.${NC}"
else
    echo -e "${RED}[FAIL] Expected HTTP 502 (escalation triggered and failed), got HTTP $HTTP_STATUS${NC}"
    curl -s -X POST "${HR_URL}/reset" > /dev/null
    exit 1
fi

# Reset headroom simulation
curl -s -X POST "${HR_URL}/reset" > /dev/null
echo -e "${GREEN}[PASS] Headroom-triggered fallback successfully validated!${NC}"
exit 0
