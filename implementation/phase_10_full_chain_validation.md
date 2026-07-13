# **Phase 10: Full Service Chain Validation**

## **Objective**

Establish a comprehensive end-to-end functional and failure integration validation script. Check the health status of all 6 components, trace token compression through Headroom, test model routing/escalation through LiteLLM, verify RAG indexing, and output a detailed status report.

---

## **Architecture Context**

This phase tests the full physical service chain configured and wired together.

```text
[User Client] ==> [LangChain (8080)] ==> [Headroom (4100)] ==> [LiteLLM (4000)] ==> [vLLM / Cloud]
                        ║
                        ╚═> [Qdrant (6333)]
```

---

## **Required Files & Directories**

* [scripts/validate-full-chain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-full-chain.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Write the Full Service Chain Validation Script**

Create [scripts/validate-full-chain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-full-chain.sh):

```bash
#!/bin/bash
# scripts/validate-full-chain.sh - Validates the health and routing of the entire stack

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;0m'

echo -e "${BLUE}[INFO] Executing Full aMMare Service Chain Validation...${NC}"

# 1. Health Checks Table
SERVICES=(
  "ammare-langchain:8080:http://localhost:8080/health"
  "ammare-local-llm:8000:http://localhost:8000/v1/models"
  "ammare-litellm:4000:http://localhost:4000/ping"
  "ammare-headroom:4100:http://localhost:4100"
  "ammare-vector-db:6333:http://localhost:6333/dashboard"
  "ammare-openhands:3000:http://localhost:3000"
)

echo -e "\n=== SERVICE COMPONENT STATUS ==="
for item in "${SERVICES[@]}"; do
  NAME=$(echo "$item" | cut -d: -f1)
  PORT=$(echo "$item" | cut -d: -f2)
  URL=$(echo "$item" | cut -d: -f3-)

  if curl -s -f --connect-timeout 2 "$URL" &> /dev/null; then
    echo -e "  $NAME (Port $PORT): ${GREEN}[PASS] Running${NC}"
  else
    echo -e "  $NAME (Port $PORT): ${RED}[FAIL] Offline/Unreachable${NC}"
  fi
done

# 2. Integration Test: Standard Request through full chain
echo -e "\n=== END-TO-END FUNCTIONAL TEST ==="
LC_URL="http://localhost:8080/query"

echo -e "${BLUE}[INFO] Sending inference query through the full service chain...${NC}"
QUERY_PAYLOAD='{"prompt": "Confirm routing path. Respond with '\''Full-chain success.'\''"}'
RESPONSE=$(curl -s -X POST "$LC_URL" \
  -H "Content-Type: application/json" \
  -d "$QUERY_PAYLOAD")

if echo "$RESPONSE" | grep -q "Full-chain success"; then
    echo -e "${GREEN}[PASS] End-to-end response path validated.${NC}"
else
    echo -e "${RED}[FAIL] End-to-end query returned invalid response: $RESPONSE${NC}"
    exit 1
fi

# 3. Escalation test (Stop local LLM, trigger cloud fall back)
echo -e "\n=== FAILURE TOLERANCE & ESCALATION TEST ==="
echo -e "${BLUE}[INFO] Temporarily stopping local LLM endpoint...${NC}"
docker stop ammare-local-llm > /dev/null

echo -e "${BLUE}[INFO] Testing automatic escalation to cloud model...${NC}"
ESC_PAYLOAD='{"prompt": "Say: escalated success"}'
ESC_RESPONSE=$(curl -s -X POST "$LC_URL" \
  -H "Content-Type: application/json" \
  -d "$ESC_PAYLOAD")

# Start local LLM back up immediately to restore stack state
docker start ammare-local-llm > /dev/null

if echo "$ESC_RESPONSE" | grep -q "escalation_triggered" && echo "$ESC_RESPONSE" | grep -iq "success"; then
    echo -e "${GREEN}[PASS] System successfully bypassed local failure and escalated to Cloud Model.${NC}"
else
    echo -e "${RED}[FAIL] Escalation failed or did not return expected marker: $ESC_RESPONSE${NC}"
    exit 1
fi

echo -e "\n${GREEN}[PASS] Full service chain validation completed successfully!${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/validate-full-chain.sh
```

---

## **Validation & Success Criteria**

Execute the script to audit the running stack:

```bash
./scripts/validate-full-chain.sh
```

### **Success Criteria**

* All 6 component services print `[PASS] Running` in the status log.
* Functional test queries complete successfully.
* Graceful escalation test returns correct escalation codes when `ammare-local-llm` is offline.

---

## **Troubleshooting**

* **Local Model fails to restore:** If the validation script fails during recovery, wait a few seconds and run `./scripts/validate-local-llm.sh` to ensure the Qwen model is fully reloaded into VRAM.
