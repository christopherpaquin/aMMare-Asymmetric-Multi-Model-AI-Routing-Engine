import logging
import urllib.request
from fastapi import FastAPI
from pydantic import BaseModel

# Configure JSON-style structured logging
logging.basicConfig(
    level=logging.INFO,
    format='{"time":"%(asctime)s", "level":"%(levelname)s", "service":"ammare-headroom", "message":"%(message)s"}',
)
logger = logging.getLogger("ammare-headroom")

app = FastAPI(title="aMMare Resource Headroom Daemon")

# Try to initialize NVML
nvml_enabled = False
try:
    import pynvml

    pynvml.nvmlInit()
    nvml_enabled = True
    logger.info("NVIDIA Management Library (NVML) initialized successfully.")
except Exception as e:
    logger.warning(f"NVML initialization failed: {str(e)}. Operating in MOCK mode.")

# Global state for simulation
simulated_headroom = None


class SimulationRequest(BaseModel):
    headroom_percent: float


def check_vllm_alive() -> bool:
    try:
        # Check vLLM API models endpoint
        url = "http://ammare-local-llm:8000/v1/models"
        req = urllib.request.Request(url, method="GET")
        with urllib.request.urlopen(req, timeout=1.0) as response:
            if response.status == 200:
                return True
    except Exception as e:
        logger.debug(f"vLLM health check failed: {str(e)}")
    return False


@app.get("/status")
def get_status():
    global simulated_headroom

    # Check if a simulation override is active
    if simulated_headroom is not None:
        logger.info(f"Returning simulated headroom: {simulated_headroom}%")
        return {
            "vram_headroom_percent": simulated_headroom,
            "status": "nominal" if simulated_headroom >= 10.0 else "low",
            "nvml_enabled": nvml_enabled,
            "simulation_active": True,
            "vllm_active": False,
        }

    # Critical check: if local vLLM is active and responding, override raw VRAM check
    if check_vllm_alive():
        logger.info(
            "vLLM model engine is running and responding. Reporting nominal status."
        )
        return {
            "vram_headroom_percent": 100.0,
            "status": "nominal",
            "nvml_enabled": nvml_enabled,
            "simulation_active": False,
            "vllm_active": True,
        }

    # Query NVML if enabled (only if vLLM is not active/responding)
    if nvml_enabled:
        try:
            device_count = pynvml.nvmlDeviceGetCount()
            lowest_headroom = 100.0

            for idx in range(device_count):
                handle = pynvml.nvmlDeviceGetHandleByIndex(idx)
                info = pynvml.nvmlDeviceGetMemoryInfo(handle)
                # Calculate headroom
                free_percent = (info.free / info.total) * 100.0
                if free_percent < lowest_headroom:
                    lowest_headroom = free_percent
                logger.info(
                    f"GPU {idx}: Total={info.total / (1024**2):.1f}MB, Free={info.free / (1024**2):.1f}MB, Headroom={free_percent:.1f}%"
                )

            return {
                "vram_headroom_percent": round(lowest_headroom, 2),
                "status": "nominal" if lowest_headroom >= 10.0 else "low",
                "nvml_enabled": True,
                "simulation_active": False,
                "vllm_active": False,
            }
        except Exception as e:
            logger.error(f"Error querying NVML stats: {str(e)}")
            # Fall through to mock if query fails

    # Default Mock Mode (nominal 15.0% headroom)
    return {
        "vram_headroom_percent": 15.0,
        "status": "nominal",
        "nvml_enabled": False,
        "simulation_active": False,
        "vllm_active": False,
    }


@app.post("/simulate-oom")
def simulate_oom(request: SimulationRequest):
    global simulated_headroom
    simulated_headroom = request.headroom_percent
    logger.info(f"Simulation set: VRAM headroom = {simulated_headroom}%")
    return {"message": f"Simulation active. Headroom set to {simulated_headroom}%"}


@app.post("/reset")
def reset_simulation():
    global simulated_headroom
    simulated_headroom = None
    logger.info("Simulation reset. Using live values.")
    return {"message": "Simulation reset."}
