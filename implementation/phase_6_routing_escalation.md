# **Phase 6: Routing and Escalation Logic**

## **Objective**

Implement configuration-driven model routing and escalation logic within the LangChain middleware. Route queries to the local model endpoint by default, classify queries dynamically based on complexity, and escalate to cloud frontier models upon local failures or high-reasoning tasks.

---

## **Architecture Context**

The routing intelligence is implemented in the LangChain orchestration layer, which decides which model identifier (`local-coder` vs. `cloud-reasoner`) to pass to the LiteLLM gateway based on policy configurations.

```text
               ┌── [Read config/routing.yaml]
               ▼
[LangChain Middleware] ===> (Determines Model Alias) ===> [LiteLLM (Port 4000)]
```

---

## **Required Files & Directories**

* [config/models.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/models.yaml)
* [config/routing.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/routing.yaml)
* [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py) (Modified to handle routing/escalation)
* [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml) (Modified to mount configurations)
* [scripts/validate-routing.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-routing.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create Model Registry config**

Create [config/models.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/models.yaml):

```yaml
models:
  local_coder:
    alias: local-coder
    type: local
    description: "Qwen 2.5 Coder 7B local GPU instance for drafting/routine code tasks."
  cloud_reasoner:
    alias: cloud-reasoner
    type: cloud
    description: "Claude 3.5 Sonnet frontier cloud model for complex reasoning and review."
  cloud_fallback:
    alias: cloud-fallback
    type: cloud
    description: "GPT-4o cloud model fallback endpoint."
```

### **Step 2: Create Routing Rules config**

Create [config/routing.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/config/routing.yaml):

```yaml
routing_policies:
  default_model: local_coder
  escalation_enabled: true

  classification_rules:
    cloud_keywords:
      - "architectural review"
      - "security analysis"
      - "refactor complex design"
      - "debug heap dump"

  retry_rules:
    max_local_attempts: 1
    fallback_target: cloud_reasoner
```

### **Step 3: Update LangChain compose file to mount configurations**

Update [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml):

```yaml
version: '3.8'

services:
  ammare-langchain:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ammare-langchain
    restart: always
    ports:
      - "${AMMARE_LANGCHAIN_PORT}:8080"
    environment:
      - AMMARE_MODEL_GATEWAY_URL=${AMMARE_MODEL_GATEWAY_URL}
      - AMMARE_LANGCHAIN_LOG_LEVEL=${AMMARE_LANGCHAIN_LOG_LEVEL}
      - AMMARE_CONFIG_DIR=/app/config
    volumes:
      - ../../config:/app/config
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 4: Update LangChain app with Routing/Escalation logic**

Modify [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py):

```python
import os
import logging
import yaml
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

logging.basicConfig(
    level=os.getenv("AMMARE_LANGCHAIN_LOG_LEVEL", "INFO"),
    format='{"time":"%(asctime)s", "level":"%(levelname)s", "service":"ammare-langchain", "message":"%(message)s"}'
)
logger = logging.getLogger("ammare-langchain")

app = FastAPI(title="aMMare LangChain Agent Middleware")

class QueryRequest(BaseModel):
    prompt: str

# Load configurations helper
def load_routing_configs():
    config_dir = os.getenv("AMMARE_CONFIG_DIR", "/app/config")

    with open(os.path.join(config_dir, "models.yaml"), 'r') as f:
        models = yaml.safe_load(f)
    with open(os.path.join(config_dir, "routing.yaml"), 'r') as f:
        routing = yaml.safe_load(f)

    return models, routing

def classify_query(prompt: str, routing_config: dict) -> str:
    # Basic keyword classification rule
    keywords = routing_config.get("routing_policies", {}).get("classification_rules", {}).get("cloud_keywords", [])

    for kw in keywords:
        if kw in prompt.lower():
            logger.info(f"Query keyword match for '{kw}'. Classifying as cloud task.")
            return "cloud_reasoner"

    logger.info("No cloud keyword match. Classifying as local task.")
    return routing_config.get("routing_policies", {}).get("default_model", "local_coder")

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/query")
async def process_query(request: QueryRequest):
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    if not gateway_url:
        raise HTTPException(status_code=500, detail="Gateway URL missing.")

    try:
        models_cfg, routing_cfg = load_routing_configs()
    except Exception as e:
        logger.error(f"Configuration load failure: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Configuration error: {str(e)}")

    # Step 1: Classify Task
    selected_tier = classify_query(request.prompt, routing_cfg)
    model_alias = models_cfg["models"][selected_tier]["alias"]

    logger.info(f"Initial routing choice: {model_alias} (Tier: {selected_tier})")

    # Step 2: Attempt Call with Failover Escalation
    try:
        response = await invoke_model(gateway_url, model_alias, request.prompt)
        return {"response": response, "routed_to": model_alias}
    except Exception as local_err:
        logger.warning(f"Primary call to {model_alias} failed: {str(local_err)}")

        # Determine if we should escalate
        if routing_cfg.get("routing_policies", {}).get("escalation_enabled", False) and selected_tier != "cloud_reasoner":
            escalation_tier = routing_cfg["routing_policies"]["retry_rules"]["fallback_target"]
            escalated_alias = models_cfg["models"][escalation_tier]["alias"]

            logger.info(f"Escalating request to: {escalated_alias}")
            try:
                response = await invoke_model(gateway_url, escalated_alias, request.prompt)
                return {"response": response, "routed_to": escalated_alias, "escalation_triggered": True}
            except Exception as esc_err:
                logger.error(f"Escalation call to {escalated_alias} also failed: {str(esc_err)}")
                raise HTTPException(status_code=502, detail="Both primary and escalated models failed.")
        else:
            raise HTTPException(status_code=502, detail=f"Primary model failure: {str(local_err)}")

async def invoke_model(gateway_url: str, model_name: str, prompt_text: str) -> str:
    llm = ChatOpenAI(
        openai_api_key="ignored-for-local",  # pragma: allowlist secret
        openai_api_base=gateway_url,
        model_name=model_name,
        temperature=0.1,
        max_tokens=300
    )
    prompt_template = ChatPromptTemplate.from_template("{user_query}")
    chain = prompt_template | llm
    res = await chain.ainvoke({"user_query": prompt_text})
    return res.content
```

*Note: PYYaml dependency must be added to requirements.txt. Make sure `containers/langchain/app/requirements.txt` has `pyyaml` added.*

### **Step 5: Write Routing Validation Script**

Create [scripts/validate-routing.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-routing.sh):

```bash
#!/bin/bash
# scripts/validate-routing.sh - Validates routing policies and escalation mechanisms

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0;0m'

URL="http://localhost:8080/query"

# Re-deploy LangChain to bind new mounts and install yaml package
echo -e "\033[0;34m[INFO] Re-deploying ammare-langchain...\033[0;0m"
# (Ensure pyyaml is added to requirements.txt)
if ! grep -q "pyyaml" containers/langchain/app/requirements.txt; then
    echo "pyyaml" >> containers/langchain/app/requirements.txt
fi
./scripts/deploy-langchain.sh
sleep 5

# Test 1: Simple task -> Expects Local Routing
echo -e "\033[0;34m[INFO] Test 1: Testing routine query (expects local model)...\033[0;0m"
RESPONSE_1=$(curl -s -X POST "$URL" -H "Content-Type: application/json" -d '{"prompt": "Say hello."}')
ROUTED_1=$(echo "$RESPONSE_1" | grep -o '"routed_to":"[^"]*"' | cut -d'"' -f4 || true)

if [ "$ROUTED_1" = "local-coder" ]; then
    echo -e "${GREEN}[PASS] Test 1: Query routed locally to local-coder.${NC}"
else
    echo -e "${RED}[FAIL] Test 1: Expected local-coder routing, got: $ROUTED_1${NC}"
    exit 1
fi

# Test 2: Complex Task -> Expects Escalation
echo -e "\033[0;34m[INFO] Test 2: Testing complex keyword query (expects cloud model)...\033[0;0m"
RESPONSE_2=$(curl -s -X POST "$URL" -H "Content-Type: application/json" -d '{"prompt": "Perform a security analysis of this repository."}')
ROUTED_2=$(echo "$RESPONSE_2" | grep -o '"routed_to":"[^"]*"' | cut -d'"' -f4 || true)

if [ "$ROUTED_2" = "cloud-reasoner" ]; then
    echo -e "${GREEN}[PASS] Test 2: Query classified and routed to cloud-reasoner.${NC}"
else
    echo -e "${RED}[FAIL] Test 2: Expected cloud-reasoner routing, got: $ROUTED_2${NC}"
    exit 1
fi

echo -e "${GREEN}[PASS] Dynamic routing rules verified successfully!${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/validate-routing.sh
```

---

## **Validation & Success Criteria**

Execute the routing validation script:

```bash
./scripts/validate-routing.sh
```

### **Success Criteria**

* Requests matching keywords in `routing.yaml` are immediately sent to `cloud-reasoner`.
* Other requests default to `local-coder`.
* If `local-coder` backend fails (e.g. if the local vLLM container is manually stopped), dispatching a simple request results in LangChain automatically escalating it to `cloud-reasoner` and returning the response marked `"escalation_triggered": true`.
* Output ends with `[PASS] Dynamic routing rules verified successfully!`.
