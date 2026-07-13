# **Phase 12: Documentation, Hardening, and Release Packaging**

## **Objective**

Enforce security hardening policies on all containers, verify that no secrets or API keys leak in logs or commits, establish a pre-flight release checklist, list known limitations, and document deferred V2 features.

---

## **Architecture Context**

This phase focuses on the operational readiness, security boundary isolation, and shipping standards of the aMMare platform.

```text
[Inbound Client Traffic] ===> [Strict Firewall / Security Boundary] ===> [aMMare Containers]
```

---

## **Required Files & Directories**

* [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml) (Hardened with read-only filesystems & user drops)
* [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml) (Hardened settings)

---

## **Step-by-Step Instructions**

### **Step 1: Implement Container Security Hardening**

To prevent a compromised LLM response from exploiting the host system, apply Docker security profiles to the service containers.

Update [containers/langchain/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/langchain/docker-compose.yaml) with these security overlays:

```yaml
version: '3.8'

services:
  ammare-langchain:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ammare-langchain
    restart: always
    user: "1000:1000" # Run as non-root user
    read_only: true    # Enable read-only container root file system
    tmpfs:
      - /tmp           # Writeable temporary space
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL            # Drop all Linux capabilities
    ports:
      - "${AMMARE_LANGCHAIN_PORT}:8080"
    environment:
      - AMMARE_MODEL_GATEWAY_URL=${AMMARE_MODEL_GATEWAY_URL}
      - AMMARE_LANGCHAIN_LOG_LEVEL=${AMMARE_LANGCHAIN_LOG_LEVEL}
      - AMMARE_CONFIG_DIR=/app/config
    volumes:
      - ../../config:/app/config:ro # Mount configurations as read-only
    networks:
      - ammare-network

networks:
  ammare-network:
    external: true
    name: ammare-network
```

Apply similar security restrictions to LiteLLM in [containers/litellm/docker-compose.yaml](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/containers/litellm/docker-compose.yaml).

### **Step 2: Establish the Release Checklist**

Ensure the following checks are run prior to tagging a release:

1. **Secret Leak Verification:** Scan codebase for committed API keys using baseline detectors:

   ```bash
   detect-secrets scan --exclude-files 'env/*.env.example'
   ```

2. **Linting Check:** Execute pre-commit checks:

   ```bash
   pre-commit run --all-files
   ```

3. **Validation Run:** Spin up the stack in `full` profile mode and verify all tests pass:

   ```bash
   ./scripts/deploy.sh -p full
   ./scripts/validate.sh
   ```

4. **Environment Wipe:** Reset environment overrides to prevent shipping user details:

   ```bash
   ./scripts/uninstall.sh -x
   ```

---

## **Known Limitations**

* **Local Model VRAM Constraints:** The Qwen2.5-Coder-7B model requires dual NVIDIA RTX 3060 GPUs to support tensor parallelism. Attempting to run on a single 12GB VRAM GPU may lead to out-of-memory (OOM) errors during dense context tasks.
* **Lossy Token Compression:** Headroom's context compression algorithm is lossy. If your prompts require highly specific coding formatting (e.g. complex patch files), token compression should be bypassed using header flags.
* **Network Latency:** Dynamic routing and cloud fallback add round-trip overhead (approximately 200ms - 500ms depending on cloud model API latency).

---

## **Deferred V2 Features**

* **User-Level Budgets:** Individual virtual keys under LiteLLM do not support auto-resetting monthly spend quotas; this requires database configuration storage.
* **Multi-Agent Collaboration Pools:** Combining multiple middleware systems (e.g. Autogen + LangChain) is deferred to the next release.
* **Auto-Tuning Routing rules:** Dynamically adjusting model thresholds based on real-time cost-performance analysis is deferred.
* **Self-Healing agent loops:** The capability of the agent middleware to rewrite its own failing tool policies dynamically.
