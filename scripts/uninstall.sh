#!/bin/bash
# scripts/uninstall.sh - Stops and removes all aMMare services

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

CONTAINERS=(
  "ammare-openhands"
  "ammare-headroom"
  "ammare-langchain"
  "ammare-litellm"
  "ammare-qdrant"
  "ammare-local-llm"
)

echo -e "${BLUE}[INFO] Uninstalling all aMMare engine services...${NC}"

# Tear down using Docker Compose where possible
COMPOSITIONS=(
  "containers/openhands/docker-compose.yaml"
  "containers/headroom/docker-compose.yaml"
  "containers/langchain/docker-compose.yaml"
  "containers/litellm/docker-compose.yaml"
  "containers/qdrant/docker-compose.yaml"
  "containers/local-llm/docker-compose.yaml"
)

for comp in "${COMPOSITIONS[@]}"; do
    if [ -f "$comp" ]; then
        echo -e "${BLUE}[INFO] Tearing down compose stack: $comp${NC}"
        $SUDO docker compose -f "$comp" down 2>/dev/null || true
    fi
done

# Force stop any lingering containers
for c in "${CONTAINERS[@]}"; do
    if $SUDO docker ps -a --format '{{.Names}}' | grep -q "^${c}$"; then
        echo -e "${BLUE}[INFO] Force-removing lingering container: ${c}${NC}"
        $SUDO docker rm -f "${c}" 2>/dev/null || true
    fi
done

# Remove the virtual bridge network
echo -e "${BLUE}[INFO] Removing virtual network ammare-network...${NC}"
$SUDO docker network rm ammare-network 2>/dev/null || true

echo -e "${GREEN}[PASS] Uninstall complete. All containers and networks have been cleared.${NC}"
exit 0
