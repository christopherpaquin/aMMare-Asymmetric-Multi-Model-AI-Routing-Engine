# **Phase 2: LangChain Middleware Layer**

## **Objective**

Deploy the `ammare-langchain` orchestration middleware inside a containerized Python environment. Establish API routing, custom prompt templates, JSON logging, health endpoints, and the ability to consume model endpoints through a logical model gateway variable.

---

## **Architecture Context**

The LangChain middleware acts as the brain and security boundary of the system. In this phase, it serves as the entry-point service, exposing port `8080` to the LAN subnet.

```text
[LAN Client] ===> [LangChain (8080)] ===> [vLLM Endpoint (8000)]
```

---

## **Required Files & Directories**

* [env/langchain.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/langchain.env.example)
* [containers/langchain/Dockerfile](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/Dockerfile)
* [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py)
* [containers/langchain/app/requirements.txt](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/requirements.txt)
* [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml)
* [scripts/deploy-langchain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-langchain.sh)
* [scripts/validate-langchain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-langchain.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create the Environment Template**

Create [env/langchain.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/langchain.env.example):

```bash
# ==============================================================================
# ammare-langchain Environment Configuration Template
# ==============================================================================

# Listening port for LangChain middleware (exposed to LAN)
AMMARE_LANGCHAIN_PORT=8080

# Logical Model Gateway URL (Phase 2 points directly to local vLLM endpoint)
AMMARE_MODEL_GATEWAY_URL=http://ammare-local-llm:8000/v1

# Target model to specify in requests
AMMARE_LANGCHAIN_MODEL_NAME=Qwen/Qwen2.5-Coder-7B-Instruct

# Middleware logging level: DEBUG | INFO | WARNING | ERROR
AMMARE_LANGCHAIN_LOG_LEVEL=INFO

# Safety configuration profiles: restrictive | permissive
AMMARE_SAFETY_PROFILE=restrictive
```

### **Step 2: Create Python dependencies**

Create [containers/langchain/app/requirements.txt](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/requirements.txt):

```text
fastapi>=0.100.0
uvicorn>=0.22.0
langchain>=0.1.0
langchain-openai>=0.0.2
pydantic>=2.0
python-dotenv>=1.0.0
```

### **Step 3: Develop LangChain FastAPI application**

Create [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py):

```python
import os
import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

# Configure JSON-style structured logging
logging.basicConfig(
    level=os.getenv("AMMARE_LANGCHAIN_LOG_LEVEL", "INFO"),
    format='{"time":"%(asctime)s", "level":"%(levelname)s", "service":"ammare-langchain", "message":"%(message)s"}'
)
logger = logging.getLogger("ammare-langchain")

app = FastAPI(title="aMMare LangChain Agent Middleware")

class QueryRequest(BaseModel):
    prompt: str

# Health Checkpoint Endpoint
@app.get("/health")
def health_check():
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    logger.info(f"Health check invoked. Configured Gateway: {gateway_url}")
    return {
        "status": "healthy",
        "configured_gateway": gateway_url,
        "model_name": os.getenv("AMMARE_LANGCHAIN_MODEL_NAME")
    }

# Core Query Request Processing
@app.post("/query")
async def process_query(request: QueryRequest):
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    model_name = os.getenv("AMMARE_LANGCHAIN_MODEL_NAME")

    if not gateway_url:
        logger.error("Missing AMMARE_MODEL_GATEWAY_URL environment variable.")
        raise HTTPException(status_code=500, detail="Model gateway URL is unconfigured.")

    logger.info(f"Routing request to model gateway: {gateway_url} using model: {model_name}")

    try:
        # Initialize ChatOpenAI pointing to the model gateway
        llm = ChatOpenAI(
            openai_api_key="ignored-for-local",  # pragma: allowlist secret
            openai_api_base=gateway_url,
            model_name=model_name,
            temperature=0.2,
            max_tokens=500
        )

        # Simple Prompt Template
        prompt = ChatPromptTemplate.from_template(
            "You are an expert AI development assistant operating within the aMMare platform.\n"
            "User query: {user_query}\n"
            "Respond clearly and concisely."
        )

        chain = prompt | llm
        response = await chain.ainvoke({"user_query": request.prompt})

        logger.info("Model invocation succeeded.")
        return {"response": response.content}

    except Exception as e:
        logger.error(f"Failed to communicate with model gateway: {str(e)}")
        raise HTTPException(status_code=502, detail=f"Upstream model gateway error: {str(e)}")
```

### **Step 4: Create Dockerfile**

Create [containers/langchain/Dockerfile](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/Dockerfile):

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app/

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
```

### **Step 5: Define Compose Stack**

Create [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml):

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
      - AMMARE_LANGCHAIN_MODEL_NAME=${AMMARE_LANGCHAIN_MODEL_NAME}
      - AMMARE_LANGCHAIN_LOG_LEVEL=${AMMARE_LANGCHAIN_LOG_LEVEL}
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

*(Note: We will leverage a shared bridge network named `ammare-network` to allow internal DNS service resolution between containers.)*

### **Step 6: Write deployment and validation scripts**

Create [scripts/deploy-langchain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-langchain.sh):

```bash
#!/bin/bash
# scripts/deploy-langchain.sh - Deploys LangChain container middleware

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

# Source environment
if [ -f env/langchain.env ]; then
    export $(grep -v '^#' env/langchain.env | xargs)
else
    echo -e "${RED}[FAIL] langchain.env not found. Please copy env/langchain.env.example to env/langchain.env.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Creating ammare-network bridge network if missing...${NC}"
docker network create ammare-network 2>/dev/null || true

echo -e "${BLUE}[INFO] Building and starting ammare-langchain middleware...${NC}"
docker compose -f containers/langchain/docker-compose.yaml up -d --build

echo -e "${GREEN}[PASS] ammare-langchain deployment initiated.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy-langchain.sh
```

Create [scripts/validate-langchain.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-langchain.sh):

```bash
#!/bin/bash
# scripts/validate-langchain.sh - Health check for langchain middleware

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

PORT=${AMMARE_LANGCHAIN_PORT:-8080}
URL="http://localhost:${PORT}"

echo -e "${BLUE}[INFO] Querying ammare-langchain health checkpoint...${NC}"

for i in {1..10}; do
    if RESPONSE=$(curl -s -f "${URL}/health"); then
        echo -e "${GREEN}[PASS] ammare-langchain responds to health query.${NC}"
        echo -e "${BLUE}[INFO] Health Details: $RESPONSE${NC}"
        exit 0
    fi
    echo -e "${BLUE}[INFO] Waiting for LangChain container (attempt $i/10)...${NC}"
    sleep 3
done

echo -e "${RED}[FAIL] LangChain health check failed.${NC}"
exit 1
```

Make executable:

```bash
chmod +x scripts/validate-langchain.sh
```

---

## **Validation & Success Criteria**

1. Copy configuration overrides:

   ```bash
   cp env/langchain.env.example env/langchain.env
   ```

2. Execute deployment:

   ```bash
   ./scripts/deploy-langchain.sh
   ```

3. Run validation:

   ```bash
   ./scripts/validate-langchain.sh
   ```

### **Success Criteria**

* LangChain container builds and starts without error.
* Querying `http://localhost:8080/health` responds with HTTP 200 and prints the configured parameters.
* Validations output `[PASS] ammare-langchain responds to health query.`.

---

## **Troubleshooting**

* **External Network Error:** If Docker Compose errors out complaining that `ammare-network` does not exist, ensure the network is created by executing: `docker network create ammare-network`.
