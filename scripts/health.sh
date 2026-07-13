#!/bin/bash
# scripts/health.sh - Checks the status of the deployed aMMare containers

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source global env
if [ -f env/ammare.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            export "${line?}"
        fi
    done < env/ammare.env
fi

PROFILE=${AMMARE_DEPLOY_PROFILE:-minimal-local}

echo -e "${BLUE}[INFO] Checking health status for profile: '${PROFILE}'${NC}"

# Define expected containers based on profile
CONTAINERS=()
case $PROFILE in
  "minimal-local")
    CONTAINERS=("ammare-local-llm" "ammare-langchain")
    ;;
  "hybrid")
    CONTAINERS=("ammare-local-llm" "ammare-litellm" "ammare-langchain")
    ;;
  "full")
    CONTAINERS=("ammare-local-llm" "ammare-litellm" "ammare-headroom" "ammare-vector-db" "ammare-openhands" "ammare-langchain")
    ;;
esac

echo -e "\n=== Container Status ==="
ALL_HEALTHY=true
for container in "${CONTAINERS[@]}"; do
  STATUS=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null || true)
  STATUS=$(echo "$STATUS" | tr -d '\r\n')
  if [ -z "$STATUS" ]; then
    STATUS="not-deployed"
  fi

  if [ "$STATUS" = "running" ]; then
    echo -e "  $container: ${GREEN}[RUNNING]${NC}"
  elif [ "$STATUS" = "not-deployed" ]; then
    echo -e "  $container: ${RED}[NOT DEPLOYED]${NC}"
    ALL_HEALTHY=false
  else
    echo -e "  $container: ${RED}[$STATUS]${NC}"
    ALL_HEALTHY=false
  fi
done

if [ "$ALL_HEALTHY" = true ]; then
  echo -e "\n${GREEN}[PASS] All containers in active profile are running successfully!${NC}"
  exit 0
else
  echo -e "\n${RED}[FAIL] One or more containers are unhealthy or missing.${NC}"
  exit 1
fi
