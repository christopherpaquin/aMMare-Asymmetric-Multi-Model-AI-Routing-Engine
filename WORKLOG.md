# **aMMare Project Worklog & Decisions**

This file maintains a chronological history of implementation actions, key design decisions, and architectural justifications. Future development agents must review this log before proposing further modifications to the codebase.

---

## **Current Project Status**

* **Scaffold Mode:** All step-by-step implementation guide markdown files have been designed and written.
* **Agent Rules:** The system constraints and documentation requirements are codified in `rules.md`.
* **Exclusions Check:** Baseline `.gitignore` has been reviewed and verified to exclude all system `*.env` configuration targets.

---

## **Chronological Log**

### **2026-07-12**

#### **1. Core Repository Architecture Analysis**

* **Action:** Reviewed the 212KB deep-dive architecture document: [aMMare - Asymmetric Multi-Model AI Routing Engine - V1.2.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/architecture/aMMare%20-%20Asymmetric%20Multi-Model%20AI%20Routing%20Engine%20-%20V1.2.md).
* **Outcome:** Mapped out the service chain structure, dependencies, ports, and configuration rules.

#### **2. Created Phase-by-Phase Implementation Guides**

* **Action:** Created the `implementation/` directory and wrote 13 module guides (Phase 0 to Phase 12) + index README.
* **Files Created:**
  * [README.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/README.md) - Main directory map.
  * [phase_0_scaffold.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_0_scaffold.md) - Base setup, linters, preflight check.
  * [phase_1_local_llm.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_1_local_llm.md) - `vLLM` container, GPU allocations, tensor parallelism config.
  * [phase_2_langchain_middleware.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_2_langchain_middleware.md) - `FastAPI` / `LangChain` middleware container.
  * [phase_3_workflow_validation.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_3_workflow_validation.md) - Integration of minimal chain.
  * [phase_4_litellm_routing.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_4_litellm_routing.md) - `LiteLLM` proxy setup.
  * [phase_5_cloud_provider.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_5_cloud_provider.md) - Frontier cloud integration (Anthropic/OpenAI/Gemini).
  * [phase_6_routing_escalation.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_6_routing_escalation.md) - Dynamic keyword classification & automatic fallback code.
  * [phase_7_headroom_integration.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_7_headroom_integration.md) - `Headroom` context optimization proxy and bypass rules.
  * [phase_8_openhands_integration.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_8_openhands_integration.md) - `OpenHands` workspace container integration.
  * [phase_9_memory_retrieval.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_9_memory_retrieval.md) - `Qdrant` vector storage and embedding/RAG pipelines.
  * [phase_10_full_chain_validation.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_10_full_chain_validation.md) - End-to-end integration and failure tests.
  * [phase_11_one_click_deployment.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_11_one_click_deployment.md) - Unified `deploy.sh`, `uninstall.sh`, and `validate.sh` scripts.
  * [phase_12_hardening_packaging.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/implementation/phase_12_hardening_packaging.md) - Security rules and release checklist.

#### **3. Implemented Agent Rules & Overhauled main README**

* **Action:** Created [rules.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/rules.md) containing guidelines for documentation, worklogging, security, and verification. Overhauled the root [README.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/README.md) to integrate guides and document execution operations (Start, Stop, Validate).

---

## **Design & Implementation Decisions**

### **Vector Database Choice: Qdrant**

* **Decision:** Selected `Qdrant` (`qdrant/qdrant:latest`) as the primary database for memory storage in Phase 9.
* **Rationale:** Qdrant is lightweight, high-performance, runs out-of-the-box in a container with minimal memory overhead, exposes an intuitive REST and gRPC API, and integrates cleanly with LangChain's vectorstore libraries.

### **Service Routing Gateway Abstraction**

* **Decision:** Sourced the model base base URL inside the LangChain middleware application from a single global environment variable (`AMMARE_MODEL_GATEWAY_URL`) rather than hardcoding.
* **Rationale:** As the system progresses through development phases, the gateway URL changes (`vLLM` -> `LiteLLM` -> `Headroom`). Storing this in environment configuration prevents code rewriting and ensures compatibility.

### **Container Isolation and Hardening**

* **Decision:** Dropped all default Linux capability privileges (`cap_drop: - ALL`), enforced a read-only container root file system (`read_only: true`), and dropped user contexts to `1000:1000`.
* **Rationale:** The LangChain container handles raw LLM inputs and executes shell operations. Restricting its filesystem prevents unauthorized directory creations, command injections, or runtime modification of the agent core files.

---

## **Planned Tasks**

* **Task 1:** Wait for User authorization and review of implementation guides.
* **Task 2:** Propose Phase 0 execution, setting up baseline configurations, environment templates, and preflight check script files.
