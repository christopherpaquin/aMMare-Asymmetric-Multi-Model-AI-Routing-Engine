#!/bin/bash
# scripts/validate.sh - Master orchestrator to run all service validations

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

echo -e "${BLUE}[INFO] Running complete aMMare Validation Test Suite...${NC}"

VALIDATIONS=(
  "./scripts/validate-local-llm.sh"
  "./scripts/validate-litellm.sh"
  "./scripts/validate-langchain.sh"
  "./scripts/validate-headroom.sh"
  "./scripts/validate-openhands.sh"
  "./scripts/validate-memory.sh"
  "./scripts/validate-headroom-fallback.sh"
  "./scripts/validate-phase6-routing.sh"
  "./scripts/validate-full-chain.sh"
)

ALL_PASS=true

for val in "${VALIDATIONS[@]}"; do
    echo -e "\n${BLUE}>>> Running validation: ${val} <<<${NC}"
    if $SUDO "$val"; then
        echo -e "${GREEN}[PASS] ${val} passed.${NC}"
    else
        echo -e "${RED}[FAIL] ${val} failed.${NC}"
        ALL_PASS=false
    fi
done

echo -e "\n=== Final Validation Summary ==="
if [ "$ALL_PASS" = true ]; then
    echo -e "${GREEN}[SUCCESS] All validation scripts passed! Platform is 100% operational.${NC}"
    exit 0
else
    echo -e "${RED}[FAILURE] One or more validations failed. Please review logs above.${NC}"
    exit 1
fi
