#!/bin/bash
# scripts/deploy.sh - One-click modular deployment script for aMMare

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

show_help() {
    echo "Usage: ./scripts/deploy.sh [OPTIONS]"
    echo "Options:"
    echo "  --all              Deploy the entire stack (default)"
    echo "  --minimal-local    Deploy local inference only (local-llm, langchain, litellm)"
    echo "  --local-llm        Deploy local-llm container only"
    echo "  --langchain        Deploy langchain container only"
    echo "  --litellm          Deploy litellm container only"
    echo "  --headroom         Deploy headroom container only"
    echo "  --openhands        Deploy openhands container only"
    echo "  --memory           Deploy qdrant container only"
    echo "  --help             Show this help screen"
}

# Create shared network
echo -e "${BLUE}[INFO] Setting up shared docker network...${NC}"
docker network create ammare-network 2>/dev/null || true

DEPLOY_ALL=true
DEPLOY_LLM=false
DEPLOY_LC=false
DEPLOY_LITE=false
DEPLOY_HR=false
DEPLOY_OH=false
DEPLOY_QD=false

if [ $# -gt 0 ]; then
    DEPLOY_ALL=false
    while [ $# -gt 0 ]; do
        case "$1" in
            --all) DEPLOY_ALL=true ;;
            --minimal-local)
                DEPLOY_LLM=true
                DEPLOY_LC=true
                DEPLOY_LITE=true
                ;;
            --local-llm) DEPLOY_LLM=true ;;
            --langchain) DEPLOY_LC=true ;;
            --litellm) DEPLOY_LITE=true ;;
            --headroom) DEPLOY_HR=true ;;
            --openhands) DEPLOY_OH=true ;;
            --memory) DEPLOY_QD=true ;;
            --help) show_help; exit 0 ;;
            *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
        esac
        shift
    done
fi

if [ "$DEPLOY_ALL" = true ]; then
    DEPLOY_LLM=true
    DEPLOY_LC=true
    DEPLOY_LITE=true
    DEPLOY_HR=true
    DEPLOY_OH=true
    DEPLOY_QD=true
fi

# Run deploy scripts in order of dependency
if [ "$DEPLOY_LLM" = true ]; then
    echo -e "\n${BLUE}=== Deploying local LLM endpoint (vLLM) ===${NC}"
    $SUDO ./scripts/deploy-local-llm.sh
fi

if [ "$DEPLOY_LITE" = true ]; then
    echo -e "\n${BLUE}=== Deploying LiteLLM router proxy ===${NC}"
    $SUDO ./scripts/deploy-litellm.sh
fi

if [ "$DEPLOY_LC" = true ]; then
    echo -e "\n${BLUE}=== Deploying LangChain middleware ===${NC}"
    $SUDO ./scripts/deploy-langchain.sh
fi

if [ "$DEPLOY_HR" = true ]; then
    echo -e "\n${BLUE}=== Deploying Headroom GPU daemon ===${NC}"
    $SUDO ./scripts/deploy-headroom.sh
fi

if [ "$DEPLOY_OH" = true ]; then
    echo -e "\n${BLUE}=== Deploying OpenHands agent server ===${NC}"
    $SUDO ./scripts/deploy-openhands.sh
fi

if [ "$DEPLOY_QD" = true ]; then
    echo -e "\n${BLUE}=== Deploying Qdrant memory database ===${NC}"
    $SUDO ./scripts/deploy-memory.sh
fi

echo -e "\n${GREEN}[PASS] Deployment procedures completed successfully.${NC}"
exit 0
