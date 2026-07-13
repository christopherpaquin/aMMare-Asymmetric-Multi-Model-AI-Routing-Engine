import os
import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

# Configure JSON-style structured logging
logging.basicConfig(
    level=os.getenv("AMMARE_LANGCHAIN_LOG_LEVEL", "INFO"),
    format='{"time":"%(asctime)s", "level":"%(levelname)s", "service":"ammare-langchain", "message":"%(message)s"}',
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
        "model_name": os.getenv("AMMARE_LANGCHAIN_MODEL_NAME"),
    }


# Core Query Request Processing
@app.post("/query")
async def process_query(request: QueryRequest):
    gateway_url = os.getenv("AMMARE_MODEL_GATEWAY_URL")
    model_name = os.getenv("AMMARE_LANGCHAIN_MODEL_NAME")

    if not gateway_url:
        logger.error("Missing AMMARE_MODEL_GATEWAY_URL environment variable.")
        raise HTTPException(
            status_code=500, detail="Model gateway URL is unconfigured."
        )

    logger.info(
        f"Routing request to model gateway: {gateway_url} using model: {model_name}"
    )

    try:
        # Initialize ChatOpenAI pointing to the model gateway
        llm = ChatOpenAI(
            openai_api_key="ignored-for-local",  # pragma: allowlist secret
            openai_api_base=gateway_url,
            model_name=model_name,
            temperature=0.2,
            max_tokens=500,
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
        raise HTTPException(
            status_code=502, detail=f"Upstream model gateway error: {str(e)}"
        )
