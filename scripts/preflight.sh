#!/bin/bash
# scripts/preflight.sh - Host environment validation script

set -euo pipefail

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;0m'

echo -e "${BLUE}[INFO] Running Host Preflight Checks...${NC}"

# Check Docker Installation
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[FAIL] Docker is not installed or not in PATH.${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Docker is installed.${NC}"
fi

# Check Docker Compose (v2)
if ! docker compose version &> /dev/null; then
    echo -e "${RED}[FAIL] Docker Compose (v2) is not installed.${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Docker Compose is installed.${NC}"
fi

# Check NVIDIA GPU and Container Toolkit
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}[PASS] NVIDIA GPU found.${NC}"
    if docker run --help | grep -q -- "--gpus"; then
        echo -e "${GREEN}[PASS] NVIDIA Container Toolkit integrated with Docker.${NC}"
    else
        echo -e "${YELLOW}[WARN] NVIDIA GPUs found but Docker --gpus option not verified.${NC}"
    fi
else
    echo -e "${YELLOW}[WARN] No NVIDIA GPU found on this system. GPU-enabled containers may fail.${NC}"
fi

# Validate project directory structure
REQUIRED_DIRS=("config" "containers" "env" "scripts" "tests")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}[PASS] Directory '${dir}/' exists.${NC}"
    else
        echo -e "${RED}[FAIL] Required directory '${dir}/' is missing.${NC}"
        exit 1
    fi
done

echo -e "${GREEN}[PASS] Preflight checks passed successfully!${NC}"
exit 0
