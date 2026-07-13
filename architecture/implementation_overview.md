# aMMare Implementation & Integration Phases Overview

This document provides a summary of each deployment phase of the **Asymmetric Multi-Model AI Routing Engine (aMMare)**, explaining the core components, responsibilities, ports, and links to the detailed implementation guides.

---

## Deployment & Integration Roadmap

### [Phase 0: Repository Scaffold & Baseline Standards](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_0_scaffold.md)

* **Overview:** Establishes the repository's foundational directory structure, pre-commit styling and code quality hooks (Ruff, ShellCheck, Markdownlint, Detect-secrets), environment configuration templates (`env/*.env.example`), and baseline diagnostic scripts ([preflight.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/preflight.sh) & [health.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/health.sh)).
* **Responsibility:** Developer tooling, secrets prevention, and environment readiness validation.

### [Phase 1: Local LLM Endpoint (vLLM)](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_1_local_llm.md)

* **Overview:** Sets up and configures the local vLLM container running the `Qwen/Qwen2.5-Coder-7B-Instruct` model. It configures dual NVIDIA RTX 3060 GPUs using tensor parallelism (`tensor-parallel-size=2`) and maps host-level caches to optimize weights lookup.
* **Responsibility:** High-speed, local offline code generation.
* **Service Port:** `8000`

### [Phase 2: LangChain Middleware Layer](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_2_langchain_middleware.md)

* **Overview:** Scaffolds the containerized FastAPI middleware utilizing LangChain. It abstracts standard prompt logic, implements robust JSON logging, and isolates execution boundaries via read-only container layouts.
* **Responsibility:** State orchestration, safety sandboxing, and LLM API gateway interface.
* **Service Port:** `8080`

### [Phase 3: Direct Local Model Workflow Validation](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_3_workflow_validation.md)

* **Overview:** Connects the LangChain agent middleware directly to the vLLM container to validate the basic query-and-response channel. It tests direct inference paths, mock timeouts, and validates HTTP 502 recovery handling when the backend LLM goes offline.
* **Responsibility:** Core connectivity testing.

### [Phase 4: LiteLLM Routing Layer](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_4_litellm_routing.md)

* **Overview:** Configures and deploys the LiteLLM proxy container to act as a latency-based router. It creates virtual alias targets for local-coder and external model routes and establishes bearer key authentication policies.
* **Responsibility:** Latency routing, spend governance, and model endpoint abstraction.
* **Service Port:** `4000`

### [Phase 5: Cloud Model Provider Integration](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_5_cloud_provider.md)

* **Overview:** Integrates external APIs (Anthropic Claude 3.5 Sonnet and OpenAI GPT-4o) as frontier backup systems. It secures API keys in a git-ignored environment configuration and builds connection smoke tests that gracefully skip when no keys are configured.
* **Responsibility:** Complex reasoning fallback routes.

### [Phase 6: Routing and Escalation Logic](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_6_routing_escalation.md)

* **Overview:** Implements asymmetric routing and cloud escalation rules in the LangChain container. If a query matches specific keywords (e.g. `architect`, `security`) or exceeds character thresholds, it is automatically escalated to LiteLLM's cloud reasoning routes.
* **Responsibility:** Context-based routing.

### [Phase 7: Headroom Integration](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_7_headroom_integration.md)

* **Overview:** Deploys a Resource Headroom Daemon that queries Nvidia NVML to track VRAM consumption. If free VRAM drops below 10%, the LangChain middleware triggers a cloud safety bypass to prevent OOM errors. It checks vLLM's liveness endpoint to prevent false alarms due to vLLM's pre-allocated memory caches.
* **Responsibility:** OOM prevention.
* **Service Port:** `8001`

### [Phase 8: OpenHands Integration](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_8_openhands_integration.md)

* **Overview:** Integrates the OpenHands autonomous developer container into the aMMare Docker network. It connects the workspace agent directly to the aMMare LiteLLM gateway, allowing OpenHands to run local tasks on Qwen2.5-Coder.
* **Responsibility:** Autonomous coding workstation workspace.
* **Service Port:** `3000`

### [Phase 9: Memory, Context, and Retrieval (RAG)](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_9_memory_retrieval.md)

* **Overview:** Deploys the Qdrant vector database container to store and retrieve contextual embeddings. This supports semantic lookup of files and conversation history to enrich agent prompts.
* **Responsibility:** Long-term memory and retrieval.
* **Service Port:** `6333`

### [Phase 10: Full Service Chain Validation](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_10_full_chain_validation.md)

* **Overview:** Implements end-to-end integration tests that verify data flow through the entire topology: `Client -> OpenHands -> LangChain middleware -> LiteLLM router -> Local vLLM (with Headroom overrides)`.
* **Responsibility:** Integrated system check.

### [Phase 11: One-Click Modular Deployment](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_11_one_click_deployment.md)

* **Overview:** Consolidates all environment deployment, uninstallation, and validation scripts into a unified set of orchestrators: [deploy.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/deploy.sh), [uninstall.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/uninstall.sh), and [validate.sh](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/scripts/validate.sh).
* **Responsibility:** Lifecycle management and platform orchestration.

### [Phase 12: Hardening & Packaging](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_12_hardening_packaging.md)

* **Overview:** Standardizes platform release checklist rules, production environment variables audits, container system capabilities restriction, and read-only filesystem policies.
* **Responsibility:** Production readiness hardening.
