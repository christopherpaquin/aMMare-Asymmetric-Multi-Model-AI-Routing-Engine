# aMMare - Asymmetric Multi-Model AI Routing Engine

<p align="center">
  <img src="logos/aMMare-logo-concept-A-asymmetric-split.svg" alt="aMMare Logo" width="60%" />
</p>

<p align="center">
  <a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-brightgreen?style=for-the-badge&logo=pre-commit&logoColor=white" alt="Pre-Commit" /></a>
  <a href="https://github.com/astral-sh/ruff"><img src="https://img.shields.io/badge/Ruff-Linter-red?style=for-the-badge" alt="Ruff" /></a>
  <a href="https://www.shellcheck.net/"><img src="https://img.shields.io/badge/ShellCheck-Linter-yellow?style=for-the-badge" alt="ShellCheck" /></a>
  <a href="https://github.com/igorshubovych/markdownlint-cli"><img src="https://img.shields.io/badge/Markdownlint-MD-blue?style=for-the-badge" alt="Markdownlint" /></a>
  <br>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/LangChain-⚡-green?style=for-the-badge" alt="LangChain Orchestration" />
  <img src="https://img.shields.io/badge/LiteLLM-Proxy-blue?style=for-the-badge" alt="LiteLLM" />
  <img src="https://img.shields.io/badge/vLLM-Local_LLM-orange?style=for-the-badge" alt="vLLM" />
</p>

---

## Executive Summary

The **Asymmetric Multi-Model AI Routing Engine (aMMare)** is a containerized agentic AI toolchain designed to provide a practical, local-first development assistant. By separating model reasoning from tool execution, `aMMare` utilizes local and cloud-hosted AI models through a controlled, governed service chain.

Unlike a simple local chatbot, `aMMare` coordinates real developer workflows (such as modifying files, running tests, inspecting logs, and executing Git operations) using a stateful orchestration layer. Routine tasks are routed to local model endpoints (reducing API costs and preserving data privacy), while complex reasoning tasks or failed local iterations are escalated to high-capacity frontier cloud models.

---

## Architecture & Service Chain

The system is designed around a physical service-chain model. Requests flow from the User Interface into the agent layer, through context optimization and routing proxies, and down to the active model endpoint:

```text
[User Interface / OpenHands]
            │
            ▼
[LangChain Agent Middleware]  ◄─── (Tool Execution & Safety Boundary)
            │
            ▼
[Headroom Context Proxy]      ◄─── (Token Optimization & Payload Compression)
            │
            ▼
[LiteLLM Routing Gateway]     ◄─── (Governance, Budgets, and Virtual Keys)
            │
      ┌─────┴────────┐
      ▼              ▼
[vLLM Endpoint]   [Frontier Cloud APIs]
(Local RTX GPUs)   (Claude / GPT-4 / Gemini)
```

### Component Responsibilities

* **User Interface Layer:** The entry point (CLI, Web UI, or IDE integration) where developers submit requests and review execution logs, summaries, and diffs.
* **OpenHands Workspace:** A containerized browser-based workspace functioning as a visual IDE for autonomous coding agent runs.
* **LangChain Agent Middleware:** The stateful controller and execution boundary. It defines prompt templates, governs tool execution (reading/writing files, executing shell commands, running tests), validates model outputs, and determines escalation events.
* **Headroom Proxy:** An inline proxy designed to compress context and optimize token payloads to reduce latency and downstream model costs.
* **LiteLLM Proxy:** The single unified API gateway. It manages model endpoint routing, fallback paths, virtual keys, spend tracking, and quota policies.
* **Local vLLM Model Endpoint:** Multi-GPU local inference runtime running open-source code models. Optimized for routine coding tasks and local privacy.
* **Frontier Model Cloud API:** External API provider endpoint used for complex reasoning, final code reviews, and fallback routing.

---

## Tool Execution & Safety Model

`aMMare` enforces a **Default Deny** safety profile. All tool execution is mediated and validated by the LangChain middleware:

1. **Local Workspace Boundaries:** File read/write operations are confined to defined project folders.
2. **Command Execution Controls:** Allowed shell commands are verified against an Approved Tool Registry.
3. **Human Approval Gates:** High-risk actions (e.g., executing scripts, committing code, network calls) can require user confirmation before execution.
4. **Credential Protection:** Active secrets and API keys are blocked from being logged, committed, or sent to model providers.

---

## Development Roadmap

The project is structured around 13 distinct development phases:

* **Phase Zero: Repository Scaffold and Baseline Standards**
  * Initialize directory structure, config folders, styling guidelines, and pre-commit automation.
* **Phase One: Local LLM Endpoint**
  * Deploy vLLM local container, configure multi-GPU parallelisms for laboratory GPUs (e.g., dual NVIDIA RTX 3060s), and expose a logical model gateway.
* **Phase Two: LangChain Middleware Layer**
  * Deploy LangChain middleware container, define service interface, logging models, and health endpoints.
* **Phase Three: Direct Local Model Workflow Validation**
  * Validate direct LangChain to local LLM logic, confirming tool selection and observation feedback loops.
* **Phase Four: LiteLLM Routing Layer**
  * Introduce LiteLLM proxy to abstract model endpoint targets, adding virtual keys and usage logging.
* **Phase Five: Cloud Model Provider Integration**
  * Add cloud-hosted frontier model APIs to LiteLLM, configuring fallback routes and failover controls.
* **Phase Six: Routing and Escalation Logic**
  * Implement confidence and complexity-based routing rules to determine when tasks escalate from local to cloud.
* **Phase Seven: Headroom Integration**
  * Place Headroom inline as an optimization proxy, configuring bypass filters for structured payloads.
* **Phase Eight: OpenHands Integration**
  * Integrate containerized OpenHands workspace into the model service chain.
* **Phase Nine: Memory, Context, and Retrieval**
  * Implement session context management, runtime task state tracking, and local vector retrieval.
* **Phase Ten: Full Service Chain Validation**
  * End-to-level system testing: routing, tool safety, escalation, and context compression.
* **Phase Eleven: One-Click Modular Deployment**
  * Write top-level orchestrators and environment installers for easy local workspace spin-up.
  * *Includes Docker Compose configurations and systemd service profiles.*
* **Phase Twelve: Documentation, Hardening, and Release Packaging**
  * Audit security boundaries, complete API documentation, package release bundles, and baseline configurations.

---

## Getting Started

### Local Setup & Hook Installation

This repository implements rigorous linting, code quality, and security checks via `pre-commit` hooks. These checks run locally before code files are staged or committed.

1. **Clone the Repository:**

    ```bash
    git clone git@github.com:christopherpaquin/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine.git
    cd aMMare-Asymmetric-Multi-Model-AI-Routing-Engine
    ```

2. **Install Pre-Commit Hooks:**
    Ensure you have `pre-commit` installed, then register the hooks:

    ```bash
    pre-commit install && pre-commit install --hook-type commit-msg
    ```

3. **Run Checks Manually:**
    To scan all files in the repository for style, linting, and secrets validation:

    ```bash
    pre-commit run --all-files
    ```

### Installed Linters & Checks

* **Trailing Whitespace & End of Files:** Ensures standard formatting constraints.
* **Ruff:** Lints and formats Python files.
* **ShellCheck:** Validates Bash scripts for syntax, logic errors, and security issues.
* **Markdownlint:** Enforces styling guidelines across documentation files.
* **Detect Secrets:** Scans all files in the repository against a baseline to prevent accidental commits of keys/secrets.
* **Commit Message Secret Scanner:** A custom local `commit-msg` hook that intercepts commit message files, strips comment tags, and alerts if secrets are typed into the commit text.

---

## Document Control

* **Document ID:** `ARCH-AMMARE-2026-V1.2`
* **Author:** Chris Paquin
* **Date:** July 2026
