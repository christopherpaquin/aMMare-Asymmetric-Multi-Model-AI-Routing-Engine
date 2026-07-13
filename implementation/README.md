# **aMMare Implementation Guide**

Welcome to the step-by-step implementation guide for the **Asymmetric Multi-Model AI Routing Engine (aMMare)**. This directory contains detailed execution plans, file scaffolds, configurations, and validation criteria for each of the 13 roadmap phases outlined in the [aMMare Architecture Document](../architecture/aMMare%20-%20Asymmetric%20Multi-Model%20AI%20Routing%20Engine%20-%20V1.2.md).

---

## **Directory Structure Overview**

During the implementation process, you will build and organize the repository into the following structure:

```text
aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/
├── architecture/          # High-level architecture docs and assets
├── config/                # Service-specific configuration files (.yaml, .json, etc.)
│   ├── langchain/
│   ├── litellm/
│   ├── headroom/
│   └── ...
├── containers/            # Dockerfiles and container-specific definitions
│   ├── langchain/
│   ├── litellm/
│   └── ...
├── env/                   # Environment example templates (*.env.example) and local overrides (*.env)
├── implementation/        # Step-by-step implementation guide markdown files (this directory)
├── scripts/               # Operational, deployment, validation, and helper scripts
│   ├── deploy.sh          # Top-level orchestrator deployment script
│   ├── uninstall.sh       # Clean reset script
│   └── ...
├── tests/                 # Integration and unit tests
└── logs/                  # Ignored log files directory
```

---

## **Implementation Principles**

When implementing any phase, strictly adhere to these core architectural constraints:

1. **Physical Service-Chain Gateway:** Do not hardcode service URLs directly in code. Services must communicate using environment variables. The primary endpoint for model access is configured via `AMMARE_MODEL_GATEWAY_URL`.
2. **Idempotent Scripting:** All deployment, reset, and validation scripts must be safe to run repeatedly without causing side effects or corrupting state.
3. **Externalized Configuration:** All variables, keys, and paths must live in the `env/` directory. Create a `<service>.env.example` template for every config file. The actual `<service>.env` files containing secrets or system-specific details must be git-ignored.
4. **Validation First:** Do not progress to a new phase until the validation script for the current phase executes successfully and returns a `PASS` status.
5. **No Monolithic Scripts:** The top-level `deploy.sh` script should only orchestrate component deployment scripts (e.g., `scripts/deploy-local-llm.sh`).

---

## **Roadmap Phases**

Below is the execution path. Each phase is self-contained and must be validated before moving to the next.

### **Foundational Layers**

* [Phase 0: Repository Scaffold and Baseline Standards](phase_0_scaffold.md)
  * Set up repository directories, `.gitignore` rules, pre-commit hooks, linting rules, and foundational operational scripts.
* [Phase 1: Local LLM Endpoint](phase_1_local_llm.md)
  * Spin up the local `vLLM` container with multi-GPU tensor parallelism for the laboratory dual RTX 3060 GPUs.
* [Phase 2: LangChain Middleware Layer](phase_2_langchain_middleware.md)
  * Set up the core LangChain orchestration middleware with logging, health checkpoints, and initial schema validation.
* [Phase 3: Direct Local Model Workflow Validation](phase_3_workflow_validation.md)
  * Validate the minimal end-to-end service chain (`User -> LangChain -> Local LLM`) under normal operation and recovery.

### **Routing & Cloud Integration**

* [Phase 4: LiteLLM Routing Layer](phase_4_litellm_routing.md)
  * Integrate the LiteLLM proxy to abstract model endpoint targets and configure virtual keys.
* [Phase 5: Cloud Model Provider Integration](phase_5_cloud_provider.md)
  * Add frontier cloud model providers (Claude, GPT-4, Gemini) to the LiteLLM proxy with externalized credentials.
* [Phase 6: Routing and Escalation Logic](phase_6_routing_escalation.md)
  * Implement configuration-driven logic (`models.yaml` and `routing.yaml`) to route tasks based on complexity and fallback on failures.

### **Optimization & Agent Workspaces**

* [Phase 7: Headroom Integration](phase_7_headroom_integration.md)
  * Deploy the Headroom proxy inline for token payload compression and context optimization, complete with bypass rules.
* [Phase 8: OpenHands Integration](phase_8_openhands_integration.md)
  * Deploy the OpenHands coding agent workspace container with mount restrictions and tool safety profiles.
* [Phase 9: Memory, Context, and Retrieval](phase_9_memory_retrieval.md)
  * Integrate vector database indexing, embedding engines, and RAG injection rules into the LangChain middleware.

### **Verification & Deployment Packaging**

* [Phase 10: Full Service Chain Validation](phase_10_full_chain_validation.md)
  * Execute end-to-end functional and failure tests across the entire chain.
* [Phase 11: One-Click Modular Deployment](phase_11_one_click_deployment.md)
  * Build the top-level deploy/uninstall script orchestrators supporting modular profiles (`minimal-local`, `hybrid`, `full`).
* [Phase 12: Documentation, Hardening, and Release Packaging](phase_12_hardening_packaging.md)
  * Complete operational playbooks, perform security hardening reviews, and package release archives.

---

## **Global Environment Naming Conventions**

All environment configurations should follow this unified naming standard:

| Variable | Description |
| :--- | :--- |
| `AMMARE_DEPLOY_PROFILE` | Controls which services are deployed (`minimal-local`, `hybrid`, `full`) |
| `AMMARE_BASE_DIR` | Absolute path to the repository root directory |
| `AMMARE_DATA_DIR` | Directory containing persistent storage volumes (`data/models/`, `data/vector-db/`, etc.) |
| `AMMARE_MODEL_GATEWAY_URL` | The current active logical endpoint URL for LLM access |
| `AMMARE_GATEWAY_URL` | The client-facing port of `ammare-langchain` (e.g. `http://localhost:8080`) |
| `AMMARE_LOG_LEVEL` | Default logging verbosity (`DEBUG`, `INFO`, `WARNING`, `ERROR`) |
