#!/bin/bash
# scripts/validate-headroom.sh - Validates Headroom daemon status and simulation

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/headroom.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/headroom.env
fi

PORT=${AMMARE_HEADROOM_PORT:-8001}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying ammare-headroom status at ${URL}...${NC}"

# Check endpoint health
for i in {1..10}; do
    if RESPONSE=$(curl -s -f "${URL}/status"); then
        echo -e "${GREEN}[PASS] Headroom daemon responds to query.${NC}"
        echo -e "${BLUE}[INFO] Current Status: $RESPONSE${NC}"

        # Test simulation endpoint
        echo -e "${BLUE}[INFO] Simulating OOM condition...${NC}"
        curl -s -X POST "${URL}/simulate-oom" \
          -H "Content-Type: application/json" \
          -d '{"headroom_percent": 5.0}' > /dev/null

        SIM_STATUS=$(curl -s -f "${URL}/status")
        if echo "$SIM_STATUS" | grep -q '"status":"low"'; then
            echo -e "${GREEN}[PASS] Headroom successfully simulated low memory condition (VRAM low fallback trigger).${NC}"
        else
            echo -e "${RED}[FAIL] Simulation failed. Status: $SIM_STATUS${NC}"
            exit 1
        fi

        # Reset simulation
        echo -e "${BLUE}[INFO] Resetting simulation...${NC}"
        curl -s -X POST "${URL}/reset" > /dev/null

        RESET_STATUS=$(curl -s -f "${URL}/status")
        if echo "$RESET_STATUS" | grep -q '"simulation_active":false'; then
            echo -e "${GREEN}[PASS] Headroom simulation reset successfully (live NVML queried).${NC}"
            exit 0
        else
            echo -e "${RED}[FAIL] Reset verification failed. Status: $RESET_STATUS${NC}"
            exit 1
        fi
    fi
    echo -e "${BLUE}[INFO] Waiting for Headroom (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] Headroom validation failed.${NC}"
exit 1
