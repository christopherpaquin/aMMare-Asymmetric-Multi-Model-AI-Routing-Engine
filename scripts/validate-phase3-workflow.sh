#!/bin/bash
# scripts/validate-phase3-workflow.sh - End-to-end integration and failure tests

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

echo -e "${BLUE}[INFO] Starting Phase 3 Integration Validation...${NC}"

# Test Case 1: Functional Request Path
echo -e "${BLUE}[INFO] Test Case 1: Verifying active inference path...${NC}"
TEST_QUERY="Identify this platform and respond with 'Hello aMMare'."
RESPONSE=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "'"${TEST_QUERY}"'"}')

if echo "$RESPONSE" | grep -iq "ammare"; then
    echo -e "${GREEN}[PASS] Test Case 1: Active request path validated.${NC}"
else
    echo -e "${RED}[FAIL] Test Case 1: Invalid response: $RESPONSE${NC}"
    exit 1
fi

# Test Case 2: Graceful Error Handling (Backend Down)
echo -e "${BLUE}[INFO] Test Case 2: Stopping local-llm endpoint to test failure mode...${NC}"
sudo docker stop ammare-local-llm > /dev/null

echo -e "${BLUE}[INFO] Dispatching request with disabled model backend...${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "This query should fail gracefully."}')

if [ "$HTTP_STATUS" -eq 502 ]; then
    echo -e "${GREEN}[PASS] Test Case 2: Middleware returned correct gateway error (502).${NC}"
else
    echo -e "${RED}[FAIL] Test Case 2: Expected HTTP 502, got HTTP $HTTP_STATUS${NC}"
    # Make sure we start the container back up before failing out
    sudo docker start ammare-local-llm > /dev/null
    exit 1
fi

# Test Case 3: Automatic Recovery
echo -e "${BLUE}[INFO] Test Case 3: Restarting ammare-local-llm container...${NC}"
sudo docker start ammare-local-llm > /dev/null

echo -e "${BLUE}[INFO] Waiting for model to reload (this can take up to 2 minutes)...${NC}"
# Wait for backend to recover
sudo ./scripts/validate-local-llm.sh

echo -e "${BLUE}[INFO] Retrying integration query after backend recovery...${NC}"
RESPONSE_RETRY=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Verify system recovery and respond with '\''Recovered'\''. "}')

if echo "$RESPONSE_RETRY" | grep -iq "recovered"; then
    echo -e "${GREEN}[PASS] Test Case 3: Automatic recovery validated successfully!${NC}"
else
    echo -e "${RED}[FAIL] Test Case 3: Recovery validation failed. Output: $RESPONSE_RETRY${NC}"
    exit 1
fi

echo -e "${GREEN}[PASS] All Phase 3 Workflow Integration tests passed!${NC}"
exit 0
