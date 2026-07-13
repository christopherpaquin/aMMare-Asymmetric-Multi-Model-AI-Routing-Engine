import os
import json
import yaml
import logging
import urllib.request
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

# Configure JSON-style structured logging
logging.basicConfig(
    level=os.getenv("AMMARE_LANGCHAIN_LOG_LEVEL", "INFO"),
    format='{"time":"%(asctime)s", "level":"%(levelname)s", "service":"ammare-langchain", "message":"%(message)s"}',
)
logger = logging.getLogger("ammare-langchain")

app = FastAPI(title="aMMare LangChain Agent Middleware")


# Helper to load YAML configurations safely
def load_yaml(file_path):
    try:
        with open(file_path, "r") as f:
            return yaml.safe_load(f)
    except Exception as e:
        logger.error(f"Error loading configuration {file_path}: {str(e)}")
        return {}


CONFIG_DIR = "/app/config"
models_config = load_yaml(os.path.join(CONFIG_DIR, "models.yaml"))
routing_config = load_yaml(os.path.join(CONFIG_DIR, "routing.yaml"))


class QueryRequest(BaseModel):
    prompt: str


# Helper to query the Headroom daemon status
def check_vram_headroom(headroom_url):
    if not headroom_url:
        return True  # Assume healthy if unconfigured
    try:
        url = f"{headroom_url.rstrip('/')}/status"
        req = urllib.request.Request(url, method="GET")
        with urllib.request.urlopen(req, timeout=2) as response:
            if response.status == 200:
                data = json.loads(response.read().decode("utf-8"))
                headroom_status = data.get("status", "nominal")
                logger.info(
                    f"VRAM Headroom check result: {headroom_status} (headroom={data.get('vram_headroom_percent')}%)."
                )
                return headroom_status != "low"
    except Exception as e:
        logger.warning(
            f"Failed to query headroom daemon at {headroom_url}: {str(e)}. Assuming nominal headroom."
        )
    return True


@app.get("/health")
def health_check():
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    return {
        "status": "healthy",
        "configured_gateway": gateway_url,
        "models_count": len(models_config.get("models", [])),
        "routing_rules_loaded": "routing_rules" in routing_config,
    }


@app.post("/query")
async def process_query(request: QueryRequest):
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    if not gateway_url:
        logger.error("Missing AMMARE_MODEL_GATEWAY_URL environment variable.")
        raise HTTPException(
            status_code=500, detail="Model gateway URL is unconfigured."
        )

    # Retrieve routing configurations
    rules = routing_config.get("routing_rules", {})
    default_model = rules.get("default_route", "local-coder")
    escalation_triggers = rules.get("escalation_triggers", {})
    keywords = escalation_triggers.get("keywords", [])
    max_len = escalation_triggers.get("max_length_threshold", 4000)
    fallback_chain = rules.get("fallback_chain", {})

    # Evaluate escalation criteria
    target_model = default_model
    reason = "default routing rule"

    # 1. VRAM Headroom check
    headroom_url = os.getenv("AMMARE_HEADROOM_URL")
    if not check_vram_headroom(headroom_url):
        target_model = "cloud-reasoner"
        reason = "local GPU VRAM headroom is low (OOM safety fallback)"
    else:
        # 2. Keyword check
        for kw in keywords:
            if kw.lower() in request.prompt.lower():
                target_model = "cloud-reasoner"
                reason = f"matched escalation keyword '{kw}'"
                break

        # 3. Length check
        if len(request.prompt) > max_len:
            target_model = "cloud-reasoner"
            reason = (
                f"prompt length ({len(request.prompt)}) exceeds threshold ({max_len})"
            )

    logger.info(f"Initial target model selection: {target_model} (Reason: {reason})")

    # Traverse fallback chain if errors occur
    current_model = target_model
    master_key = os.getenv("LITELLM_MASTER_KEY", "sk-ammare-master-key-12345")

    while current_model:
        try:
            logger.info(
                f"Attempting query on model route: {current_model} via {gateway_url}"
            )

            llm = ChatOpenAI(
                openai_api_key=master_key,
                openai_api_base=gateway_url,
                model_name=current_model,
                temperature=0.2,
                max_tokens=500,
            )

            prompt = ChatPromptTemplate.from_template(
                "You are an expert AI development assistant operating within the aMMare platform.\n"
                "User query: {user_query}\n"
                "Respond clearly and concisely."
            )

            chain = prompt | llm
            response = await chain.ainvoke({"user_query": request.prompt})

            logger.info(f"Model route '{current_model}' succeeded.")
            return {
                "response": response.content,
                "model_used": current_model,
                "escalated": current_model != default_model,
            }

        except Exception as e:
            logger.warning(f"Model route '{current_model}' failed with error: {str(e)}")

            # Retrieve next model in fallback path
            next_model = fallback_chain.get(current_model)
            if next_model:
                logger.info(f"Escalating query to fallback model: {next_model}")
                current_model = next_model
            else:
                logger.error("End of fallback chain reached. Inference failed.")
                raise HTTPException(
                    status_code=502,
                    detail="aMMare Engine Routing Error: Upstream inference failed on all fallback routes.",
                )

    raise HTTPException(status_code=500, detail="Routing logic error occurred.")
