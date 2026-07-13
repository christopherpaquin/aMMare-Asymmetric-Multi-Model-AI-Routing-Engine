# **Phase 9: Memory, Context, and Retrieval**

## **Objective**

Deploy a containerized `Qdrant` vector database for memory storage, integrate it with the LangChain middleware, configure local or cloud-hosted embedding engines, and write scripts to validate indexing and retrieval.

---

## **Architecture Context**

Memory/RAG components are integrated into the LangChain orchestration layer, which fetches context from the vector database before routing prompt payloads downstream.

```text
               ┌──> [Query Vector DB] ──> [Qdrant (Port 6333)]
               ▼
[LangChain Middleware] ===> (Injects Context into Prompt) ===> [Router]
```

---

## **Required Files & Directories**

* [env/memory.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/memory.env.example)
* [containers/qdrant/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/qdrant/docker-compose.yaml)
* [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py) (Modified to connect to Qdrant)
* [scripts/deploy-memory.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-memory.sh)
* [scripts/validate-memory.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-memory.sh)

---

## **Step-by-Step Instructions**

### **Step 1: Create Memory Environment Template**

Create [env/memory.env.example](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/env/memory.env.example):

```bash
# ==============================================================================
# ammare-memory Environment Configuration Template
# ==============================================================================

# Qdrant vector database port
AMMARE_QDRANT_PORT=6333

# Storage path for persistent vector records
AMMARE_QDRANT_DATA_DIR=/home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/data/vector-db

# Embedding provider type: local-fastembed | openai | cloud
AMMARE_EMBEDDING_PROVIDER=local-fastembed
```

### **Step 2: Create Qdrant docker-compose configuration**

Create [containers/qdrant/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/qdrant/docker-compose.yaml):

```yaml
version: '3.8'

services:
  ammare-vector-db:
    image: qdrant/qdrant:latest
    container_name: ammare-vector-db
    restart: always
    ports:
      - "${AMMARE_QDRANT_PORT}:6333"
      - "6334:6334"
    volumes:
      - "${AMMARE_QDRANT_DATA_DIR}:/qdrant/storage"
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

### **Step 3: Update LangChain App with Retrieval logic**

Add dependencies `qdrant-client` and `fastembed` to [containers/langchain/app/requirements.txt](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/requirements.txt):

```text
qdrant-client>=1.7.0
fastembed>=0.2.0
```

Modify [containers/langchain/app/main.py](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/app/main.py) to integrate indexation and RAG logic:

```python
# Add imports
from qdrant_client import QdrantClient
from qdrant_client.http.models import Distance, VectorParams
from fastembed import TextEmbedding

# Initialize embedding and Qdrant client
embedding_model = TextEmbedding(model_name="BAAI/bge-small-en-v1.5")
qdrant_url = os.getenv("AMMARE_QDRANT_URL", "http://ammare-vector-db:6333")
qdrant_client = QdrantClient(url=qdrant_url)

# Setup database collection
COLLECTION_NAME = "ammare_memory"
try:
    if not qdrant_client.collection_exists(COLLECTION_NAME):
        qdrant_client.create_collection(
            collection_name=COLLECTION_NAME,
            vectors_config=VectorParams(size=384, distance=Distance.COSINE),
        )
except Exception as init_err:
    logger.warning(f"Unable to connect/setup Qdrant collection on start: {str(init_err)}")

class DocumentInput(BaseModel):
    content: str
    metadata: dict = {}

# Endpoint to store documents
@app.post("/index")
async def index_document(doc: DocumentInput):
    try:
        embeddings = list(embedding_model.embed([doc.content]))
        vector = [float(x) for x in embeddings[0]]

        # Insert record into Qdrant
        qdrant_client.upsert(
            collection_name=COLLECTION_NAME,
            points=[
                {
                    "id": hash(doc.content) % (10 ** 8),
                    "vector": vector,
                    "payload": {"content": doc.content, "metadata": doc.metadata}
                }
            ]
        )
        return {"status": "indexed", "vector_dimension": len(vector)}
    except Exception as e:
        logger.error(f"Index error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
```

*(Note: Ensure you update `/query` in `main.py` to search Qdrant for similar chunks, format them as context, and inject them into the system prompt template.)*

### **Step 4: Create deployment and validation scripts**

Create [scripts/deploy-memory.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy-memory.sh):

```bash
#!/bin/bash
# scripts/deploy-memory.sh - Deploys vector DB

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

if [ -f env/memory.env ]; then
    export $(grep -v '^#' env/memory.env | xargs)
else
    echo -e "${RED}[FAIL] memory.env not found. Please copy env/memory.env.example.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Creating Qdrant persistent data directories...${NC}"
mkdir -p "${AMMARE_QDRANT_DATA_DIR}"

echo -e "${BLUE}[INFO] Starting ammare-vector-db (Qdrant)...${NC}"
docker compose -f containers/qdrant/docker-compose.yaml up -d

echo -e "${GREEN}[PASS] ammare-vector-db deployment initiated.${NC}"
exit 0
```

Make executable:

```bash
chmod +x scripts/deploy-memory.sh
```

Create [scripts/validate-memory.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate-memory.sh):

```bash
#!/bin/bash
# scripts/validate-memory.sh - Verifies document indexation and retrieval

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0;0m'

LC_URL="http://localhost:8080"

# Re-deploy LangChain middleware to load qdrant packages and environment variables
echo -e "${BLUE}[INFO] Re-deploying ammare-langchain...${NC}"
./scripts/deploy-langchain.sh
sleep 5

echo -e "${BLUE}[INFO] Test 1: Storing a fact in memory...${NC}"
DOC_PAYLOAD='{"content": "aMMare is configured with static IP address 10.1.10.17 for local lab testing.", "metadata": {"topic": "networking"}}'

INDEX_RES=$(curl -s -X POST "${LC_URL}/index" \
  -H "Content-Type: application/json" \
  -d "$DOC_PAYLOAD")

if echo "$INDEX_RES" | grep -q "indexed"; then
    echo -e "${GREEN}[PASS] Test 1: Fact indexed successfully.${NC}"
else
    echo -e "${RED}[FAIL] Test 1: Storing document failed: $INDEX_RES${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Test 2: Querying memory context integration...${NC}"
QUERY_PAYLOAD='{"prompt": "What is the lab static IP address configured for aMMare?"}'

QUERY_RES=$(curl -s -X POST "${LC_URL}/query" \
  -H "Content-Type: application/json" \
  -d "$QUERY_PAYLOAD")

if echo "$QUERY_RES" | grep -q "10.1.10.17"; then
    echo -e "${GREEN}[PASS] Test 2: Memory correctly injected context and resolved response!${NC}"
    exit 0
else
    echo -e "${RED}[FAIL] Test 2: System responded without using retrieved memory context: $QUERY_RES${NC}"
    exit 1
fi
```

Make executable:

```bash
chmod +x scripts/validate-memory.sh
```

---

## **Validation & Success Criteria**

1. Copy configuration file:

   ```bash
   cp env/memory.env.example env/memory.env
   ```

2. Deploy Qdrant:

   ```bash
   ./scripts/deploy-memory.sh
   ```

3. Run the validation:

   ```bash
   ./scripts/validate-memory.sh
   ```

### **Success Criteria**

* Qdrant starts, exposes port 6333, and is visible on `ammare-network`.
* Document snippets can be sent to the `/index` endpoint.
* Prompt completions query Qdrant and integrate matches into downstream model prompts.

---

## **Troubleshooting**

* **Memory Out of Resources:** Running fastembed on low-end systems might cause CPU spikes during startup. Ensure at least 2GB of RAM is allocated to the LangChain container.
* **Connection Timeout to Qdrant:** Verify that `AMMARE_QDRANT_URL` in langchain environment configurations is set to `http://ammare-vector-db:6333` (the container name on the internal docker bridge network).
