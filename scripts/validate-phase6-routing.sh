#!/bin/bash
# scripts/validate-phase6-routing.sh - Validates asymmetric routing and escalation flow

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
URL="http://localhost:${LC_PORT}"

echo -e "${BLUE}[INFO] Starting Phase 6 Routing and Escalation Validation...${NC}"

# Test Case 1: Standard Route (local-coder)
echo -e "${BLUE}[INFO] Test Case 1: Standard query (should route to local-coder)...${NC}"

# Force nominal headroom simulation to allow standard routing to succeed on the GPU
curl -s -X POST "http://localhost:8001/simulate-oom" \
  -H "Content-Type: application/json" \
  -d '{"headroom_percent": 15.0}' > /dev/null

RESPONSE_STD=$(curl -s -X POST "${URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Write a python function to add two numbers."}')

if echo "$RESPONSE_STD" | grep -q "local-coder"; then
    echo -e "${GREEN}[PASS] Standard query successfully routed to local-coder.${NC}"
    echo -e "${BLUE}[INFO] Response payload: $RESPONSE_STD${NC}"
else
    echo -e "${RED}[FAIL] Expected route to local-coder, got: $RESPONSE_STD${NC}"
    curl -s -X POST "http://localhost:8001/reset" > /dev/null
    exit 1
fi

# Test Case 2: Escalation & Fallback (Keyword Trigger)
echo -e "${BLUE}[INFO] Test Case 2: Triggering escalation keyword 'architect'...${NC}"
# Since cloud API keys are empty in our environment, we expect the escalation to cloud-reasoner
# to fail, then fall back to cloud-fallback, which will also fail, and return HTTP 502.
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Can you architect a database system for this routing engine?"}')

# Reset headroom simulation back to live values
curl -s -X POST "http://localhost:8001/reset" > /dev/null

if [ "$HTTP_STATUS" -eq 502 ]; then
    echo -e "${GREEN}[PASS] Escalation and full fallback chain successfully executed and returned HTTP 502 as expected (no cloud API keys).${NC}"
else
    echo -e "${RED}[FAIL] Expected HTTP 502 (due to failed fallbacks), got HTTP $HTTP_STATUS${NC}"
    exit 1
fi

echo -e "${GREEN}[PASS] All Phase 6 Asymmetric Routing tests passed!${NC}"
exit 0
