# **Asymmetric Multi-Model AI Routing Engine (aMMare)**

## *A Containerized Agentic AI Toolchain for Local Execution, Context Compression, Model Routing, and Frontier Validation leveraging [VLLM](https://vllm.ai/), [LiteLLM](https://www.litellm.ai/), and [Headroom](https://headroomlabs.ai/).*

# **Pronunciation Guide** {#pronunciation-guide}

Ammare (or aMMare) is pronounced /ˈæm.ɑːɹ/

**Syllable 1 (/ˈæm/)**: Say the word "am" (as in, "I am"). Make sure the "a" sound is flat and sharp, like the "a" in cat or trap. Drop your jaw slightly and push the sound from the front of your mouth. 

**Syllable 2 (/.ɑːɹ/):** Say the word "marr" (as in, "This is a non-marring mallet, as I do not want to mar the new flooring during installation?"). Pronounce the M, then make a wide, open throat sound like the "ah" sound you make at the doctor, smoothly blending into a standard English "R" sound (like at the end of car or far). 

# **Table of Contents** {#table-of-contents}

[Pronunciation Guide](#pronunciation-guide)

[Table of Contents](#table-of-contents)

[Executive Summary](#executive-summary)

[Global Traffic Architecture](#global-traffic-architecture)

[Agent Execution Flow](#agent-execution-flow)

[Component Responsibilities](#“fix-syntax-bugs-in-calc.py-and-execute-it-to-verify.”)

[User Interface Layer](#user-interface-layer)

[OpenHands Container](#“fix-the-syntax-error-in-custom.py-and-run-it-to-verify-the-fix.”)

[Containerized LangChain Agent Middleware Layer](#containerized-langchain-agent-middleware-layer)

[Containerized Headroom Proxy Layer](#python3-calc.py)

[Containerized LiteLLM Proxy Layer](#heading=h.50ddbpdgqljj)

[Containerized Local Model Endpoint using vLLM](#containerized-local-model-endpoint-using-vllm)

[Frontier Model Cloud API](#frontier-model-cloud-api)

[Responsibility Boundary Summary](#responsibility-boundary-summary)

[Tool Execution and Safety Model](#tool-execution-and-safety-model)

[Core Execution Principle](#core-execution-principle)

[Tool Execution Boundary](#tool-execution-boundary)

[Approved Tool Registry](#approved-tool-registry)

[Default Deny Model](#default-deny-model)

[Human Approval Gates](#human-approval-gates)

[Read-Only First Behavior](#read-only-first-behavior)

[Command Execution Controls](#command-execution-controls)

[File Access Controls](#file-access-controls)

[Secret Handling](#secret-handling)

[Network Access Controls](#network-access-controls)

[Tool Result Filtering](#tool-result-filtering)

[Audit Logging](#audit-logging)

[Failure Handling](#failure-handling)

[Change Validation](#change-validation)

[Git and Change Control](#git-and-change-control)

[Container Isolation](#container-isolation)

[Privilege Separation](#privilege-separation)

[Policy Configuration](#policy-configuration)

[Safety Profile Modes](#safety-profile-modes)

[Final Response Requirements](#final-response-requirements)

[Summary](#summary)

[Model Routing and Escalation Strategy](#model-routing-and-escalation-strategy)

[Routing Objective](#routing-objective)

[Asymmetric Model Design](#asymmetric-model-design)

[Primary Routing Layer](#primary-routing-layer)

[Example Model Tiers](#example-model-tiers)

[Local-First Routing](#local-first-routing)

[Escalation Triggers](#escalation-triggers)

[Confidence-Based Escalation](#confidence-based-escalation)

[Tool-Aware Routing](#tool-aware-routing)

[State-Aware Routing](#state-aware-routing)

[Task Classification](#task-classification)

[Risk-Based Routing](#risk-based-routing)

[Cost and Latency Controls](#cost-and-latency-controls)

[Context Preparation Before Escalation](#context-preparation-before-escalation)

[De-Escalation](#de-escalation)

[Multi-Model Review](#multi-model-review)

[Fallback Behavior](#fallback-behavior)

[Routing Decision Logging](#routing-decision-logging)

[Policy-Driven Routing](#policy-driven-routing)

[Example Routing Flow](#example-routing-flow)

[Summary](#summary-1)

[Development and Deployment Roadmap](#development-and-deployment-roadmap)

[Roadmap Principles](#roadmap-principles)

[Phase Zero: Repository Scaffold and Baseline Standards](#phase-zero:-repository-scaffold-and-baseline-standards)

[Phase One: Local LLM Endpoint](#phase-one:-local-llm-endpoint)

[Phase Two: LangChain Middleware Layer](#phase-two:-langchain-middleware-layer)

[Phase Three: Direct Local Model Workflow Validation](#phase-three:-direct-local-model-workflow-validation)

[Phase Four: LiteLLM Routing Layer](#phase-four:-litellm-routing-layer)

[Phase Five: Cloud Model Provider Integration](#phase-five:-cloud-model-provider-integration)

[Phase Six: Routing and Escalation Logic](#phase-six:-routing-and-escalation-logic)

[Phase Seven: Headroom Integration](#phase-seven:-headroom-integration)

[Phase Eight: OpenHands Integration](#phase-eight:-openhands-integration)

[Phase Nine: Memory, Context, and Retrieval](#phase-nine:-memory,-context,-and-retrieval)

[Phase Ten: Full Service Chain Validation](#phase-ten:-full-service-chain-validation)

[Phase Eleven: One-Click Modular Deployment](#phase-eleven:-one-click-modular-deployment)

[Phase Twelve: Documentation, Hardening, and Release Packaging](#phase-twelve:-documentation,-hardening,-and-release-packaging)

[Summary](#heading=h.r7l4lq125g4x)

[Target Service Topology](#target-service-topology)

[Topology Principles](#topology-principles)

[Target Service Chain](#target-service-chain)

[Logical Endpoint Strategy](#logical-endpoint-strategy)

[Proposed Service Inventory](#proposed-service-inventory)

[Required Initial Services](#required-initial-services)

[Optional Services](#optional-services)

[Service Naming Standard](#service-naming-standard)

[Port Management](#port-management)

[Network Model](#network-model)

[Shared Configuration Paths](#shared-configuration-paths)

[Shared Runtime Paths](#shared-runtime-paths)

[Environment Variable Standards](#environment-variable-standards)

[Startup Order](#startup-order)

[Independent Troubleshooting Paths](#independent-troubleshooting-paths)

[Health Check Standard](#health-check-standard)

[Logging Standard](#logging-standard)

[Deployment Profiles](#deployment-profiles)

[Topology Update Requirement](#topology-update-requirement)

[Summary](#summary-2)

[Component Configuration Model](#component-configuration-model)

[Configuration Principles](#configuration-principles)

[Configuration Layout](#configuration-layout)

[Global Configuration](#global-configuration)

[Component Configuration](#component-configuration)

[Logical Endpoint Configuration](#logical-endpoint-configuration)

[Model Endpoint Registry](#model-endpoint-registry)

[Routing Configuration](#routing-configuration)

[Secrets Handling](#secrets-handling)

[Configuration Validation](#configuration-validation)

[Configuration Ownership](#configuration-ownership)

[Summary](#summary-3)

[Service Chaining and Rewiring Strategy](#service-chaining-and-rewiring-strategy)

[Chaining Principle](#chaining-principle)

[Logical Gateway Pattern](#logical-gateway-pattern)

[Phase-Based Chain Evolution](#phase-based-chain-evolution)

[Rewiring Events](#rewiring-events)

[Rewiring Requirements](#rewiring-requirements)

[Bypass Paths](#bypass-paths)

[Deployment Profiles](#deployment-profiles-1)

[Avoiding Early Hardcoding](#avoiding-early-hardcoding)

[Service Contract Expectations](#service-contract-expectations)

[Configuration-Driven Chain Selection](#configuration-driven-chain-selection)

[Validation After Rewiring](#validation-after-rewiring)

[Failure Isolation](#failure-isolation)

[Documentation Requirement](#documentation-requirement)

[Summary](#summary-4)

[One-Click Deployment and Modular Install Strategy](#one-click-deployment-and-modular-install-strategy)

[Deployment Principle](#deployment-principle)

[Top-Level Deployment Script](#top-level-deployment-script)

[Component Deployment Scripts](#component-deployment-scripts)

[Deployment Profiles](#deployment-profiles-2)

[Deployment Order](#deployment-order)

[Preflight Checks](#preflight-checks)

[Idempotency Requirements](#idempotency-requirements)

[Optional Component Flags](#optional-component-flags)

[Validation During Deployment](#validation-during-deployment)

[Uninstall and Reset Behavior](#uninstall-and-reset-behavior)

[Generated Files](#generated-files)

[Deployment Summary Output](#deployment-summary-output)

[Coding Agent Expectations](#coding-agent-expectations)

[Summary](#summary-5)

[Helper Scripts and Operational Tooling](#helper-scripts-and-operational-tooling)

[Tooling Principles](#tooling-principles)

[Recommended Script Categories](#recommended-script-categories)

[Core Validation Scripts](#core-validation-scripts)

[Service-Chain Validation](#service-chain-validation)

[Endpoint Testing Scripts](#endpoint-testing-scripts)

[Model Management Scripts](#model-management-scripts)

[Routing Management Scripts](#routing-management-scripts)

[Log Inspection Scripts](#log-inspection-scripts)

[Support Bundle Script](#support-bundle-script)

[Service Lifecycle Scripts](#service-lifecycle-scripts)

[Coding Agent Support](#coding-agent-support)

[Output Standards](#output-standards)

[Documentation Requirement](#documentation-requirement-1)

[Summary](#summary-6)

[Documentation Strategy](#documentation-strategy)

[Documentation Principles](#documentation-principles)

[Recommended Documentation Layout](#recommended-documentation-layout)

[Main README](#main-readme)

[Architecture Documentation](#architecture-documentation)

[Component Documentation](#component-documentation)

[Modification Guides](#modification-guides)

[Deployment Documentation](#deployment-documentation)

[Configuration Documentation](#configuration-documentation)

[Validation and Troubleshooting Documentation](#validation-and-troubleshooting-documentation)

[Coding Agent Documentation](#coding-agent-documentation)

[Documentation Update Requirement](#documentation-update-requirement)

[Avoiding Redundancy](#avoiding-redundancy)

[Summary](#summary-7)

[Coding Agent Implementation Guide](#coding-agent-implementation-guide)

[Implementation Principles](#implementation-principles)

[Phase-Based Development](#phase-based-development)

[Required Work Pattern](#required-work-pattern)

[Repository Awareness](#repository-awareness)

[Configuration Rules](#configuration-rules)

[Service Chain Rules](#service-chain-rules)

[Script Standards](#script-standards)

[Deployment Script Expectations](#deployment-script-expectations)

[Validation Requirements](#validation-requirements)

[Documentation Requirements](#documentation-requirements)

[Error Handling Expectations](#error-handling-expectations)

[Security Expectations](#security-expectations)

[Reporting Requirements](#reporting-requirements)

[Stop Conditions](#stop-conditions)

[Summary](#summary-8)

[Memory, Context, and Retrieval Strategy](#memory,-context,-and-retrieval-strategy)

[Strategy Principle](#strategy-principle)

[Session Context](#session-context)

[Runtime Task State](#runtime-task-state)

[Retrieved Context](#retrieved-context)

[Persistent Memory](#persistent-memory)

[Memory Storage Rules](#memory-storage-rules)

[Retrieval Backend](#retrieval-backend)

[Embedding Model](#embedding-model)

[Context Injection Policy](#context-injection-policy)

[Source Tracking](#source-tracking)

[Memory and Routing Interaction](#memory-and-routing-interaction)

[Memory and Tool Safety](#memory-and-tool-safety)

[Indexing Process](#indexing-process)

[Retrieval Validation](#retrieval-validation)

[Reset and Purge Behavior](#reset-and-purge-behavior)

[Documentation Requirement](#documentation-requirement-2)

[Summary](#summary-9)

[Deployment Model](#deployment-model)

[Deployment Goals](#deployment-goals)

[Initial Deployment Target](#initial-deployment-target)

[Expanded Deployment Target](#expanded-deployment-target)

[Container Runtime](#container-runtime)

[Network Model](#network-model-1)

[IP Address and DNS Strategy](#ip-address-and-dns-strategy)

[Persistent Data](#persistent-data)

[Configuration and Secrets](#configuration-and-secrets)

[Deployment Profiles](#deployment-profiles-3)

[Host Assumptions](#host-assumptions)

[Deployment Boundary](#deployment-boundary)

[Summary](#summary-10)

[Validation and Success Criteria](#validation-and-success-criteria)

[Primary Success Criteria](#primary-success-criteria)

[Validation Principles](#validation-principles)

[Phase-Level Success Criteria](#phase-level-success-criteria)

[Configuration Validation](#configuration-validation-1)

[Component Validation](#component-validation)

[Service-Chain Validation](#service-chain-validation-1)

[Model Routing Validation](#model-routing-validation)

[Tool Execution Validation](#tool-execution-validation)

[Memory and Retrieval Validation](#memory-and-retrieval-validation)

[Deployment Validation](#deployment-validation)

[Documentation Validation](#documentation-validation)

[Final System Success Criteria](#final-system-success-criteria)

[Failure Criteria](#failure-criteria)

[Summary](#summary-11)

[Deferred v2 Features](#deferred-v2-features)

[Deferral Principle](#deferral-principle)

[Deferred Features List](#deferred-features-list)

[Not Deferred](#not-deferred)

[Conditional Features](#conditional-features)

[Re-Evaluation Criteria](#re-evaluation-criteria)

[Summary](#summary-12)

[Client Tool Integration Strategy](#client-tool-integration-strategy)

[Integration Goal](#integration-goal)

[Gateway Compatibility](#gateway-compatibility)

[Client Configuration Scripts](#client-configuration-scripts)

[Manual Configuration Documentation](#manual-configuration-documentation)

[Example Configuration Values](#example-configuration-values)

[Integration Profiles](#integration-profiles)

[Tool-Specific Notes](#tool-specific-notes)

[Validation for Client Integrations](#validation-for-client-integrations)

[Safety and Permissions](#safety-and-permissions)

[Documentation Requirement](#documentation-requirement-3)

[Summary](#summary-13)

# 

# **Executive Summary** {#executive-summary}

The **Asymmetric Multi-Model AI Routing Engine, or aMMare**, is a containerized agentic AI toolchain designed to provide a practical, local-first development assistant that can use both local and cloud-hosted AI models through a controlled service chain.

The purpose of aMMare is not simply to run a local chatbot. A local chatbot can answer questions, explain code, and generate examples, but it does not automatically provide the full set of developer actions needed for useful automation. The goal of aMMare is to build a system that can assist with real development workflows, including reading and writing files, generating code changes, running scripts, reviewing command output, troubleshooting failures, running tests, inspecting logs, and optionally preparing or committing changes to Git.

This distinction is central to the architecture. A language model by itself does not directly modify files, run shell commands, monitor logs, or execute tests. The model generates text, structured responses, code, diffs, or tool-call instructions. The actual execution of local actions is handled by the agent layer. In this design, that responsibility belongs primarily to the LangChain Agent Middleware Layer.

**The aMMare service chain is designed around the following major components:**

**User Interface Layer** — The interface where the user submits requests and reviews results. This may be a web UI, CLI, IDE integration, OpenHands, or another front-end interface, such as an IDE or a CLI tool

**OpenHands** — A containerized, browser-accessible agentic development environment. OpenHands can function as a web-based IDE or agent workspace, giving the user a visual interface for agent-driven development tasks. It may be used as one of the user-facing interfaces in the aMMare stack, especially for workflows where a sandboxed browser-based development environment is preferred.

**LangChain Agent Middleware Layer** — The agent orchestration layer. This is responsible for maintaining state, defining tools, validating model responses, executing approved local actions, capturing results, and deciding whether the task should continue, retry, fail, or escalate to another model. Without this layer, an LLM is just a chatbot. We have chosen to use LangChain as the orchestration layer rather than rely on internal IDE tooling which would tie the end user to a specific User Interface

**Headroom Proxy Layer** — A context optimization proxy. This layer is intended to reduce token usage and improve efficiency by compressing or optimizing payloads before they are sent to downstream model-routing infrastructure.

**LiteLLM Proxy Layer** — The model gateway and routing layer. LiteLLM (https://www.litellm.ai/) provides a unified OpenAI-compatible interface to local and frontier models. It handles model abstraction, routing, fallback behavior, virtual keys, usage tracking, budget controls, and provider management.

**Local Model Endpoint** — A locally hosted model served through vLLM. This provides private, zero-marginal-cost inference for routine coding tasks, drafting, code explanation, simple edits, and other workloads that can be handled locally.

**Frontier Model Cloud API** — One or more cloud-hosted frontier models used for complex reasoning, final validation, architectural review, difficult debugging, or fallback when the local model is not sufficient.

The aMMare architecture is based on a physical service-chain model. Requests flow from the user-facing layer into **LangChain**, then through **Headroom,** then through **LiteLLM,** and finally to either a local **vLLM-hosted model or a frontier cloud model.** Responses return through the same proxy chain back to **LangChain**, where they are validated and acted upon.

This means that **LangChain** is not just passing messages back and forth. It is the control point for the agentic workflow. If the model returns a normal answer, LangChain may return that answer to the user. If the model returns a valid tool-call instruction, LangChain may execute the appropriate tool. If the model returns an invalid or unsafe response, LangChain can reject it, retry the request, route to a different model, or return an error to the user.

The architecture solves several problems at once.

* First, it separates model inference from tool execution. This avoids the incorrect assumption that a local model must somehow have built-in access to the filesystem or shell. Instead, the local model only needs to generate useful responses or structured tool calls, while LangChain handles the actual actions.  
* Second, it provides a local-first model strategy. Routine work can be handled by a local vLLM-hosted model, reducing dependency on paid APIs and preserving privacy for appropriate tasks.  
* Third, it preserves access to frontier models when needed. Complex reasoning, architectural validation, security review, and failed local loops can be escalated to a stronger cloud model through LiteLLM.  
* Fourth, it introduces governance around model usage. LiteLLM provides a central control plane for model access, virtual keys, spend tracking, quota management, and fallback routing. This is important because agentic workflows can generate repeated model calls, and uncontrolled loops could quickly consume paid API quota.  
* Fifth, it introduces a path for token optimization. Headroom can be placed inline as a proxy to reduce context size before requests reach LiteLLM and downstream models. This may help lower cloud model costs and may also make local model usage more practical when context size is a limiting factor.  
* Sixth, it creates a flexible interface strategy. aMMare does not need to depend on a single user interface. OpenHands can provide a containerized browser-based agent workspace. A custom web UI or CLI can provide a simpler interface. IDE integrations may be added later. The key architectural point is that these interfaces connect into the same controlled service chain.

The initial POC  of aMMare should focus on proving the core service chain with one local model, one LangChain Agent Middleware Layer, Headroom as an inline proxy, LiteLLM as the routing gateway, and at least one frontier model for fallback or validation. More advanced features, such as multiple local model pipelines, complex LangGraph workflows, long-term memory, or automated multi-agent review loops, should be treated as later enhancements after the core system is stable.

In short, aMMare is being built to turn local and cloud language models into a controlled, agentic development toolchain. The system is intended to provide the practical functionality users expect from modern AI development assistants, while preserving local execution, cost control, model flexibility, and clear separation of responsibilities between the user interface, agent layer, proxy layers, and model endpoints.

# **Global Traffic Architecture** {#global-traffic-architecture}

The Global Traffic Architecture diagram represents the physical service chain for aMMare. Each box in the diagram represents a deployed service, container, or external API dependency. The diagram is not intended to show every internal process step inside the agent loop. Internal workflow details, such as tool validation, file writes, shell execution, retry behavior, and observation handling, are described in later sections.

See Diagram Below

![][image1]

# **Agent Execution Flow** {#agent-execution-flow}

The **Global Traffic Architecture section** describes the physical service chain. This section describes what happens inside that service chain when a user submits a request that requires agentic behavior.

The most important distinction is that the service chain and the agent execution flow are related, but they are not the same thing. The service chain describes which deployed services the request passes through. The agent execution flow describes how the LangChain Agent Middleware Layer interprets the request, communicates with the model, validates the model response, performs approved actions, and decides what to do next.

In aMMare, the LangChain Agent Middleware Layer is the component responsible for turning a user request into an actionable workflow.

A user may submit a request such as:

***“Fix syntax bugs in calc.py and execute it to verify.”***

This request cannot be completed by a language model alone. The model can inspect code, suggest changes, generate a patch, or request that a command be run, but the model does not directly access the local filesystem or shell. The LangChain Agent Middleware Layer provides that missing execution capability.

**The high-level execution flow is:**

1. The user submits a request through the **User Interface Layer**.  
2. The request is sent to the **LangChain Agent Middleware Layer**.  
3. **LangChain** builds the agent context. This may include the user request, system instructions, available tools, current task state, workspace path, prior observations, and any relevant file content.  
4. **LangChain** sends the model request through the service chain.  
5. The request passes through **Headroom** for context optimization, then through **LiteLLM** for model routing.  
6. **LiteLLM** routes the request to either the local vLLM model endpoint or a frontier model cloud API.  
7. The selected model generates a response.  
8. The response returns through **LiteLLM**, then through **Headroom**, and back to **LangChain**.  
9. **LangChain** validates the model response.  
10. If the model response is a normal answer, **LangChain** may return it to the User Interface Layer.  
11. If the model response contains a valid tool call, **LangChain** executes the approved local tool.  
12. If the model response is invalid, unsafe, incomplete, or not usable, **LangChain** may retry, request correction, escalate to a frontier model, or stop the workflow and report failure.  
13. If a tool is executed, **LangChain** captures the result as an observation. This may include stdout, stderr, exit code, file diff, test result, log output, or Git status.  
14. **LangChain** adds the observation to the current agent state.  
15. **LangChain** decides whether the task is complete or whether another model call is required.  
16. The loop continues until the task succeeds, fails safely, reaches a retry limit, or requires user input.

The agent loop is what gives aMMare its practical value. Without this loop, the system would only generate code examples or recommendations. With this loop, aMMare can make controlled local changes, run commands, inspect failures, and iterate.

The **LangChain Agent Middleware Layer** must therefore be designed as a stateful execution controller, not as a simple pass-through API. It needs to understand the task objective, maintain context, track tool usage, validate model responses, enforce limits, and determine when to stop.

For example, if a model returns a tool call requesting that calc.py be executed, LangChain should not blindly execute it without validation. LangChain should verify that the requested tool exists, that the command is allowed, that the working directory is permitted, and that the action fits within the current task policy. Once approved, LangChain executes the command and captures the result.

If the command fails with a syntax error, LangChain does not treat the task as complete. Instead, it sends the error output back through the model chain with an updated prompt explaining what failed. The model can then generate a correction, and LangChain can apply the correction and rerun the command.

This process continues until the task is complete or until LangChain determines that it should stop.

The agent execution flow should also support escalation. If the local model fails repeatedly, produces invalid tool calls, or cannot resolve the issue, LangChain should be able to request assistance from a frontier model through LiteLLM. This allows aMMare to remain local-first without becoming local-only.

The intended behavior is not that every task automatically goes to the strongest model. Instead, LangChain should use the local model where practical and reserve frontier models for cases where additional reasoning, validation, or recovery is needed.

In summary, the Agent Execution Flow defines how aMMare turns model output into controlled action. The model provides reasoning and instructions. LangChain validates those instructions, executes approved tools, captures results, and continues the workflow until the task reaches a safe and useful conclusion.

# **Component Responsibilities**

This section defines the responsibility of each containerized component in the aMMare service chain. Each component has a specific role. The intent is to avoid mixing user interface behavior, agent orchestration, context optimization, model routing, and model inference into a single unclear layer.

The core service chain is composed of the following major components:

* User Interface Layer  
* OpenHands Container  
* Containerized LangChain Agent Middleware Layer  
* Containerized Headroom Proxy Layer  
* Containerized LiteLLM Proxy Layer  
* Containerized Local Model Endpoint using vLLM  
* Frontier Model Cloud APIs

The architecture should be understood as a group of cooperating services. The User Interface Layer receives requests and displays results. OpenHands provides a browser-based agent workspace. The LangChain Agent Middleware Layer owns the custom aMMare agent workflow and executes approved tools. Headroom optimizes context. LiteLLM routes and governs model traffic. vLLM provides local inference. Frontier model APIs provide fallback, validation, and high-complexity reasoning.

## **User Interface Layer** {#user-interface-layer}

The User Interface Layer is the entry point where the user submits requests and reviews results.

This layer may be implemented through one or more interfaces, including a web UI, CLI, IDE integration, OpenHands, or a future custom aMMare interface. The architecture should not depend on only one user interface. Multiple interfaces should be able to connect into the same backend service chain.

The User Interface Layer is responsible for accepting user input, displaying task status, showing final results, and presenting relevant outputs such as summaries, diffs, command output, errors, or logs.

The User Interface Layer does not need to directly execute tools. In the custom aMMare workflow, tool execution is handled by the Containerized LangChain Agent Middleware Layer. This keeps the interface simple and prevents the UI from becoming responsible for filesystem access, shell execution, or retry logic.

**Example user request:**

***“Fix the syntax error in custom.py and run it to verify the fix.”***

The User Interface Layer passes this request into the service chain. It does not need to know whether the request will be handled by the local model, a frontier model, or a retry sequence involving both.

## **OpenHands Container**

OpenHands is included as a containerized, browser-accessible agentic development environment. It can function as a web-based IDE or agent workspace where the user can interact with an autonomous coding agent through a visual interface.

Within aMMare, OpenHands should be treated as one possible user-facing interface and agent workspace. It can connect to the same model infrastructure through LiteLLM, allowing OpenHands to use local models, frontier models, or routed model configurations.

OpenHands may have its own internal agent behavior. This means it should be documented separately from the custom LangChain Agent Middleware Layer. In workflows where OpenHands is used directly, OpenHands may own more of the agent loop. In workflows using the custom aMMare UI or CLI, the Containerized LangChain Agent Middleware Layer owns the agent loop.

For the first implementation, OpenHands should be deployed as a separate container and integrated into the model service chain. It should not replace the LangChain middleware path. Both can exist in the stack as different ways to interact with the model and agent infrastructure.

## **Containerized LangChain Agent Middleware Layer** {#containerized-langchain-agent-middleware-layer}

The Containerized LangChain Agent Middleware Layer is the primary orchestration component for the custom aMMare workflow.

This service is responsible for turning a user request into a controlled agentic workflow. It maintains task state, prepares prompts, defines available tools, validates model responses, executes approved local actions, captures execution results, and determines the next step in the workflow.

This layer owns tool execution for the custom aMMare agent path. That means it may perform approved actions such as reading files, writing files, running shell commands, running tests, inspecting logs, checking Git status, generating diffs, or preparing commits.

The language model does not directly execute these actions. The model only generates a response, patch, diff, or tool-call instruction. The LangChain service receives that model output, validates it, and decides whether the requested action is allowed.

For example, if the model returns a request to run:

***python3 calc.py***

The LangChain Agent Middleware Layer validates the request before executing it. The service should confirm that the requested command is permitted, that it is being run in an approved workspace, and that it fits within the current task policy. If approved, LangChain executes the command from the configured workspace and captures stdout, stderr, the exit code, and any relevant output.

That execution result becomes an observation. LangChain can then return the result to the user, send it back to the model for additional troubleshooting, retry the task, escalate to a frontier model, or stop the workflow if the task has failed safely.

This container should include the custom aMMare agent logic, tool definitions, execution policy, retry limits, prompt templates, workspace configuration, and integration code for sending model requests through Headroom and LiteLLM.

The LangChain container should also define the boundaries of the local workspace. It should know which directories it is allowed to read from, which directories it is allowed to write to, and which commands are permitted. This is important because the model may request actions that are malformed, unnecessary, unsafe, or outside the intended task scope.

The LangChain Agent Middleware Layer should not blindly execute anything the model returns. It must validate model responses and reject malformed, unsafe, or out-of-policy tool calls. If a response is invalid, the LangChain service can retry, ask the model to correct its format, escalate to a frontier model, or stop and return an error to the user.

This layer is also responsible for managing the agent loop. A single user request may require multiple model calls and multiple local actions. For example, LangChain may ask the model to inspect a file, apply a change, run a command, capture an error, send that error back to the model, apply another change, and rerun the command. The workflow continues until the task is complete, the retry limit is reached, or the system determines that user input is required.

In summary, the Containerized LangChain Agent Middleware Layer is the control point that turns model output into safe, structured, and auditable action. It is the component that makes the system agentic. The model provides reasoning and instructions, but LangChain validates those instructions, performs approved actions, captures observations, and manages the workflow through completion

## **Containerized Headroom Proxy Layer**

The Containerized Headroom Proxy Layer is an inline context optimization service positioned between the Containerized LangChain Agent Middleware Layer and the Containerized LiteLLM Proxy Layer.

Its purpose is to reduce token usage and optimize request payloads before they reach the model-routing layer. This may help lower frontier model cost and may also improve local model usability when context size becomes a limiting factor.

The expected request path is:

| *LangChain Agent Middleware Layer \=\> Headroom Proxy Layer \=\> LiteLLM Proxy Layer.* |
| :---- |

The expected response path is:

| *LiteLLM Proxy Layer \=\>Headroom Proxy Layer \=\> LangChain Agent Middleware Layer.* |
| :---- |

Headroom should be treated as a proxy service, not as the agent orchestrator. It does not own tool execution, local file changes, retry policy, task state, model selection, or provider routing decisions. Those responsibilities remain with LangChain and LiteLLM.

Headroom’s primary responsibility is context optimization. In practical terms, this may include compressing large prompts, reducing repeated context, shortening long conversation history, or optimizing the amount of information sent downstream to the selected model.

This layer is potentially useful because agentic workflows can generate large context payloads. Repeated command output, file content, error traces, prior model responses, and task history can quickly increase token usage. If every model call includes the full uncompressed context, the system may become slower, more expensive, or less reliable.

However, Headroom must be tested carefully because agentic workflows are sensitive to exact formatting. It should not corrupt or rewrite content that must remain exact, including tool-call schemas, JSON structures, file paths, shell commands, code blocks, patches, diffs, stdout, stderr, traceback output, or test results.

For this reason, Headroom should support a bypass or disable option for workflows where exact formatting is more important than token reduction. For example, if a workflow depends on structured tool calls or precise command output, LangChain may need to send the request through the service chain without compression.

For the initial version of aMMare, Headroom should be deployed as a containerized proxy, but its behavior should be validated before it is treated as mandatory for all workflows. The system should be designed so that Headroom can be enabled, disabled, or bypassed without requiring major changes to the rest of the architecture.

In summary, the Containerized Headroom Proxy Layer provides context optimization between LangChain and LiteLLM. It is intended to improve efficiency and reduce token usage, but it must preserve the exact information required for reliable agent execution.

## **Containerized LiteLLM Proxy Layer**

The Containerized LiteLLM Proxy Layer is the model gateway for aMMare.

Its purpose is to give the rest of the system one consistent endpoint for model access. Instead of configuring LangChain, OpenHands, and other tools to talk directly to different models, those tools send their model requests to LiteLLM.

LiteLLM then decides which configured model backend should receive the request. That backend may be the local vLLM model, a frontier cloud model, or another configured provider.

LiteLLM is responsible for model routing, fallback behavior, virtual keys, budget controls, rate limits, and usage tracking.

LiteLLM does not execute local actions. It does not write files, run shell commands, inspect logs, modify code, or manage the agent loop. Those responsibilities belong to the LangChain Agent Middleware Layer, or to OpenHands when OpenHands is being used directly.

In the aMMare service chain, LiteLLM receives requests from Headroom and routes them to the selected model. When the model responds, the response returns to LiteLLM first, then flows back through Headroom to LangChain.

The initial LiteLLM configuration should include at least two model routes: one local model route pointing to vLLM, and one frontier model route pointing to a cloud provider. Additional routes can be added later.

LiteLLM should also issue separate virtual keys for different clients, such as LangChain and OpenHands. This allows aMMare to track usage by client and apply different permissions, budgets, or rate limits.

In short, LiteLLM is the control point for model access. It lets aMMare use local and cloud models through one managed interface while providing routing, fallback, cost control, and visibility.

## **Containerized Local Model Endpoint using vLLM** {#containerized-local-model-endpoint-using-vllm}

The Containerized Local Model Endpoint using vLLM provides self-hosted model inference for aMMare.

This service hosts the selected local model and exposes an OpenAI-compatible API endpoint that LiteLLM can route to. The purpose of this layer is to provide local model capacity for routine development tasks without requiring every request to use a paid frontier model.

The local vLLM endpoint may be used for tasks such as code drafting, code explanation, simple bug fixes, README updates, shell command suggestions, boilerplate generation, and other development work that does not require advanced frontier-model reasoning.

The local model should not be treated as the component that performs local actions. It does not directly write files, run commands, inspect logs, or modify a repository. It only generates model output. That output may be a normal answer, a code suggestion, a patch, a diff, or a tool-call instruction. The LangChain Agent Middleware Layer is responsible for validating and acting on that output.

For the first version of aMMare, the local model strategy should use one local model endpoint. This keeps the design simpler and allows the project to focus on proving the service chain, agent loop, and tool execution model before adding more local model complexity.

The local model should be evaluated based on how well it works inside the actual aMMare workflow, not only on benchmark scores. Important criteria include stable vLLM startup, acceptable latency, usable context length, ability to produce valid structured responses, compatibility with LangChain tool-call patterns, and ability to reason over command output or errors returned by the agent layer.

The local model endpoint should be considered replaceable. If the first selected model is not reliable enough for the desired workflow, the architecture should allow a different model to be deployed behind vLLM without requiring major changes to LangChain, Headroom, LiteLLM, or the user interface.

In summary, the Containerized Local Model Endpoint using vLLM provides the local inference capability for aMMare. It supports the local-first strategy, but it does not replace the agent layer. The model generates responses and instructions; LangChain performs approved local actions.

## **Frontier Model Cloud API** {#frontier-model-cloud-api}

The Frontier Model Cloud API represents **one or more** external high-capability model providers.

Unlike the other major components, this is not deployed as a local aMMare container. It is an external API dependency accessed through LiteLLM.

Frontier models are used for tasks where the local model is not sufficient. These may include complex debugging, architecture review, security analysis, final code review, difficult failure recovery, and fallback when the local model produces invalid or low-quality responses.

The purpose of frontier models is not to replace the local-first strategy. Their purpose is to provide controlled escalation. LiteLLM should manage access to these models through configured routes, virtual keys, rate limits, budget controls, and usage tracking.

This allows aMMare to use local inference for routine work while preserving access to stronger models when needed.

## **Responsibility Boundary Summary** {#responsibility-boundary-summary}

* The User Interface Layer accepts user requests and displays results.  
* The OpenHands Container provides a browser-based agent workspace and may act as a user-facing development environment.  
* The Containerized LangChain Agent Middleware Layer owns the custom aMMare agent loop, tool execution, response validation, state management, retries, and observations.  
* The Containerized Headroom Proxy Layer optimizes context and reduces token usage as an inline proxy.  
* The Containerized LiteLLM Proxy Layer routes model traffic, manages providers, applies fallback, tracks usage, and enforces budget controls.  
* The Containerized Local Model Endpoint using vLLM provides local model inference.  
* The Frontier Model Cloud API provides high-capability reasoning, validation, and fallback through an external provider.

This separation of responsibilities is essential to the aMMare design. It ensures that each service has a clear purpose and prevents confusion between interface, orchestration, context optimization, routing, inference, and tool execution.

# **Tool Execution and Safety Model** {#tool-execution-and-safety-model}

The aMMare platform separates model reasoning from tool execution.

The language model is allowed to reason, plan, generate responses, propose file changes, request tool usage, and produce structured instructions. It is not allowed to directly execute commands, modify files, access credentials, alter runtime state, or interact with infrastructure on its own.

All tool execution is mediated by the Containerized LangChain Agent Middleware Layer. This layer acts as the controlled execution boundary between the model and the local system.

The purpose of this design is to allow agentic workflows while preserving operational control, auditability, repeatability, and safety.

## **Core Execution Principle** {#core-execution-principle}

The model may suggest an action, but the middleware decides whether that action is allowed, how it is executed, and what result is returned.

This creates a clear separation of responsibility:

* The model performs reasoning and produces intent.  
* The middleware validates and constrains that intent.  
* Approved tools perform the actual action.  
* Results are captured and returned to the model as bounded context.

This prevents the model from becoming an unrestricted shell, file editor, or automation engine.

## **Tool Execution Boundary** {#tool-execution-boundary}

The tool execution boundary is enforced inside the Containerized LangChain Agent Middleware Layer.

This boundary controls access to approved capabilities such as:

* Reading project files.  
* Writing or modifying approved files.  
* Running limited shell commands.  
* Running tests or validation scripts.  
* Inspecting logs.  
* Checking Git status.  
* Generating diffs.  
* Preparing commits.  
* Querying approved local services.  
* Calling approved APIs.  
* Interacting with approved model endpoints.

The model does not execute these operations directly. Instead, it emits a structured request, and the middleware determines whether the request is valid.

For example, the model may request to inspect a repository file, run a test command, or apply a patch. The middleware evaluates that request against the configured policy before performing the action.

## **Approved Tool Registry** {#approved-tool-registry}

The middleware maintains an approved tool registry.

The registry defines which tools are available to the agentic workflow and what each tool is permitted to do. Each tool should have a narrow, clearly defined purpose.

Examples of registered tools may include:

* File read tool.  
* File write tool.  
* Patch application tool.  
* Shell command tool.  
* Test runner tool.  
* Git status tool.  
* Git diff tool.  
* Git commit preparation tool.  
* Log inspection tool.  
* Configuration validation tool.  
* Local API request tool.  
* Model endpoint request tool.

Each tool should define:

* Its allowed input format.  
* Its allowed execution scope.  
* Its permitted working directories.  
* Whether it can modify state.  
* Whether it requires human approval.  
* What output is returned to the model.  
* What output is written to logs.  
* What failure conditions must stop the workflow.

This registry prevents tool access from being implied or open-ended.

## **Default Deny Model** {#default-deny-model}

The tool execution model should follow a default deny approach.

If a requested action is not explicitly allowed, it is rejected.

The middleware should not assume that a command, path, API call, or file operation is safe simply because the model requested it. Safe behavior must be defined in policy.

Examples of rejected actions may include:

* Commands outside the approved command allowlist.  
* File writes outside the approved project workspace.  
* Attempts to read secrets, tokens, SSH keys, or credential files.  
* Attempts to access host-level system paths.  
* Attempts to modify container runtime configuration without approval.  
* Attempts to execute network calls to unapproved destinations.  
* Attempts to install packages without approval.  
* Attempts to delete files without approval.  
* Attempts to rewrite Git history.  
* Attempts to modify production infrastructure directly.

This approach allows the system to support useful automation without granting unrestricted local authority.

## **Human Approval Gates** {#human-approval-gates}

Some actions should require explicit human approval before execution.

Human approval gates should be used for any action that is destructive, security-sensitive, infrastructure-impacting, externally visible, or difficult to reverse.

Examples of actions that should require approval include:

* Deleting files.  
* Overwriting existing configuration files.  
* Installing packages.  
* Changing firewall rules.  
* Modifying container runtime settings.  
* Restarting services.  
* Applying infrastructure changes.  
* Sending outbound messages or API requests.  
* Creating Git commits.  
* Pushing to a remote repository.  
* Running commands with elevated privileges.  
* Accessing sensitive logs or restricted files.

The middleware should pause the workflow and present the proposed action in a clear, reviewable format. The user can then approve, reject, or modify the action.

Approval should be action-specific. Approval for one action should not grant broad approval for future unrelated actions.

## **Read-Only First Behavior** {#read-only-first-behavior}

Agentic workflows should begin in read-only mode whenever possible.

The middleware should first allow the model to inspect files, gather context, understand project structure, review logs, and evaluate current state. Write actions should occur only after the model has enough context to justify the change.

This helps prevent premature edits and reduces the risk of the model making incorrect assumptions about the environment.

A typical safe workflow should follow this pattern:

* Inspect relevant files and current state.  
* Summarize findings.  
* Propose a plan.  
* Request approval for state-changing actions.  
* Apply approved changes.  
* Validate the result.  
* Report what changed and what remains.

This pattern is especially important when working with deployment scripts, container definitions, CI workflows, security settings, and infrastructure automation.

## **Command Execution Controls** {#command-execution-controls}

Shell command execution should be tightly constrained.

The shell command tool should not provide unrestricted terminal access. Instead, it should enforce command-level policy before execution.

Controls may include:

* Command allowlists.  
* Argument validation.  
* Working directory restrictions.  
* Timeout limits.  
* Output size limits.  
* Environment variable filtering.  
* Network access restrictions.  
* Privilege restrictions.  
* Denial of shell chaining where appropriate.  
* Denial of interactive commands.  
* Denial of commands that require unrestricted TTY access.

The middleware should treat shell access as one of the highest-risk tools in the platform.

Commands such as file listing, Git status, test execution, linting, and project-local validation may be allowed with low friction. Commands that modify system state, install software, alter permissions, or affect services should require explicit approval.

## **File Access Controls** {#file-access-controls}

File access should be scoped to the approved workspace.

The middleware should define which directories the agent may read from and write to. In most cases, this should be limited to the mounted project directory and selected temporary working paths.

The model should not be able to freely read from the host filesystem.

Restricted paths should include:

* SSH keys.  
* API tokens.  
* Shell history.  
* Browser profiles.  
* Password stores.  
* System credential files.  
* Host runtime sockets.  
* Private keys.  
* Cloud provider credential files.  
* Unrelated user directories.  
* Sensitive operating system paths.

Write access should be more restrictive than read access. A file may be safe to inspect but unsafe to modify.

The middleware should also preserve file change visibility by generating diffs before and after modifications.

## **Secret Handling** {#secret-handling}

The model should not be given direct access to secrets.

Secrets may be required by the middleware or tools to interact with approved services, but those secrets should not be exposed back into the model context unless explicitly sanitized.

Secret handling should follow these principles:

* Do not place raw secrets in prompts.  
* Do not return raw secrets in tool output.  
* Redact known credential patterns from logs.  
* Restrict access to secret files.  
* Use environment variables or mounted secrets only where required.  
* Avoid storing secrets in generated artifacts.  
* Block attempts to print, summarize, transform, or exfiltrate secrets.

If a tool requires a credential, the tool should use that credential internally and return only the result required for the workflow.

## **Network Access Controls** {#network-access-controls}

Network access should be explicit and policy-controlled.

The middleware should define which network destinations the agentic workflow may access. This may include approved internal services, local model endpoints, documentation sources, source control systems, or specific APIs.

Unrestricted outbound network access should be avoided.

Network policy should account for:

* Approved destinations.  
* Approved ports.  
* Approved protocols.  
* Whether authentication is required.  
* Whether requests are read-only or state-changing.  
* Whether external calls require approval.  
* Whether the response can be returned to the model.

This is important because network access can become an exfiltration path, a command-and-control path, or an unintended production-impact path.

## **Tool Result Filtering** {#tool-result-filtering}

Tool output should be filtered before it is returned to the model.

The model only needs the information required to continue the task. It does not need unrestricted access to full command output, full logs, full environment dumps, or complete file trees.

Filtering may include:

* Truncating excessive output.  
* Removing secrets.  
* Removing irrelevant environment variables.  
* Summarizing long logs.  
* Returning only matching lines from large files.  
* Redacting tokens, keys, and passwords.  
* Blocking binary output.  
* Separating user-visible output from internal diagnostic output.

This reduces context noise and helps prevent sensitive information from being pulled into the model session.

## **Audit Logging** {#audit-logging}

All tool activity should be logged.

Audit logs should record what the model requested, what the middleware allowed or rejected, what tool was executed, what inputs were used, what outputs were returned, and whether human approval was required.

Audit logging should include:

* Request timestamp.  
* Session identifier.  
* Tool name.  
* Requested action.  
* Approved or rejected status.  
* Approval source, if applicable.  
* Working directory.  
* Command or operation summary.  
* Exit code or result status.  
* Error message, if applicable.  
* Redacted output summary.  
* File paths affected.  
* Diff summary for file modifications.

Audit logs should not store raw secrets.

The audit trail is important for troubleshooting, security review, reproducibility, and understanding how a generated change was produced.

## **Failure Handling** {#failure-handling}

Tool execution failures should be handled explicitly.

The middleware should capture failures and return structured results to the model. The model can then reason about the failure and propose a correction, but it should not be allowed to repeatedly execute risky actions without control.

Failures may include:

* Invalid tool input.  
* Policy rejection.  
* Command timeout.  
* Non-zero command exit.  
* Permission failure.  
* Missing file.  
* Failed validation.  
* Failed test run.  
* API error.  
* Network timeout.  
* Unsafe output detection.

For repeated failures, the middleware should be able to stop the workflow and ask for human direction.

This prevents runaway loops where the model repeatedly retries commands or makes increasingly broad changes to resolve an issue.

## **Change Validation** {#change-validation}

State-changing actions should be followed by validation.

After modifying files, applying a patch, updating configuration, or preparing a deployment change, the middleware should run approved validation steps where available.

Validation may include:

* Syntax checks.  
* Unit tests.  
* Linting.  
* ShellCheck.  
* YAML validation.  
* JSON validation.  
* Markdown validation.  
* Container Quadlet validation.  
* Dry-run deployment commands.  
* Git diff review.  
* Security scanning.  
* Project-specific health checks.

The validation result should be returned to the model and included in the final task summary.

If validation fails, the model may propose a corrective change, but the correction should follow the same tool execution and approval rules as the original change.

## **Git and Change Control** {#git-and-change-control}

Git operations should be handled carefully.

The middleware may allow the model to inspect Git status, review diffs, and prepare commit messages. However, committing, tagging, pushing, rebasing, resetting, or altering history should require explicit user approval, If a user requests git commit, or git push actions, the user should be prompted to allow such actions. 

A safe Git workflow should include:

* Inspect current branch.  
* Inspect working tree state.  
* Review changed files.  
* Generate a diff.  
* Summarize intended changes.  
* Run validation.  
* Run pre-commit  
* Prepare a commit message.  
* Request approval before committing.  
* Request approval again before pushing.

This ensures that the user remains in control of repository history and remote publication.

## **Container Isolation** {#container-isolation}

The middleware and tool execution services should run inside containers.

Container isolation provides an additional boundary between the agentic workflow and the host system. The container should receive only the mounts, environment variables, network access, and permissions required for the task.

The container should avoid unnecessary privileges, and be configured to start up in the proper order upon system reboot. 

Recommended controls include:

* Non-root container users where possible.  
* Read-only mounts where practical.  
* Narrow bind mounts.  
* No host root filesystem mount.  
* No unrestricted container socket access.  
* Limited Linux capabilities.  
* SELinux enforcement where applicable.  
* Resource limits for CPU and memory.  
* Network segmentation.  
* Explicit volume definitions.  
* Controlled access to model endpoints and local APIs.

Container isolation is not a complete security boundary by itself, but it reduces the blast radius of tool execution.

## **Privilege Separation** {#privilege-separation}

The platform should separate privileged operations from normal agentic operations.

Most workflows should run with non-privileged permissions. Privileged actions should be routed through narrowly scoped tools or approval gates.

For example, a normal file inspection tool should not have the same authority as a service restart tool. A Git diff tool should not have the same authority as a Git push tool. A test runner should not have the same authority as a package installation tool.

This separation allows the platform to grant the minimum authority required for each action.

## **Policy Configuration** {#policy-configuration}

Tool policy should be configurable rather than hardcoded into model prompts.

The model prompt may describe expected behavior, but enforcement must happen in middleware policy.

Policy configuration may define:

* Allowed tools.  
* Allowed paths.  
* Allowed commands.  
* Denied commands.  
* Approved network destinations.  
* Human approval requirements.  
* Maximum output size.  
* Maximum runtime.  
* File write restrictions.  
* Secret redaction rules.  
* Logging requirements.  
* Retry limits.  
* Environment-specific restrictions.

This allows different deployments of aMMare to use different safety profiles.

For example, a personal homelab deployment may allow broader local file access inside a project directory, while a shared enterprise deployment may require stricter approval gates, tighter network policy, and more detailed audit logging.

## **Safety Profile Modes** {#safety-profile-modes}

The platform may support multiple safety profile modes.

Example modes include:

* Read-only mode.  
* Local development mode.  
* Assisted edit mode.  
* Approved execution mode.  
* Restricted infrastructure mode.  
* Enterprise controlled mode.

Each mode can expose a different set of tools and approval requirements.

Read-only mode may allow file inspection and summarization only. Local development mode may allow tests and project-local edits. Restricted infrastructure mode may require approval for any state-changing action. Enterprise controlled mode may integrate with identity, policy, ticketing, and audit systems.

These modes make the platform adaptable without changing the core architecture.

## **Final Response Requirements** {#final-response-requirements}

At the end of a workflow, the middleware should require the model to produce a clear final summary.

The final response should identify:

* What was inspected.  
* What was changed.  
* What was not changed.  
* What validation was performed.  
* Whether validation passed or failed.  
* What risks or limitations remain.  
* Whether human follow-up is required.  
* Where relevant diffs, logs, or artifacts can be reviewed.

This ensures that the user receives an operationally useful result rather than a vague statement that the task is complete.

## **Summary** {#summary}

The aMMare tool execution and safety model is based on controlled delegation.

The model provides reasoning and intent, but the middleware owns execution control. Tools are explicitly registered, scoped, validated, logged, and constrained. Human approval is required for risky or irreversible actions. Secrets, file access, shell execution, network calls, and Git operations are all treated as controlled capabilities rather than unrestricted model permissions.

This design allows aMMare to support practical agentic workflows while maintaining clear boundaries around safety, accountability, and operational control.

# **Model Routing and Escalation Strategy** {#model-routing-and-escalation-strategy}

The aMMare platform uses an asymmetric model-routing strategy.

Not every request should be sent to the same model. Different tasks require different levels of reasoning, speed, cost, context length, tool access, and reliability. The routing layer decides which model should handle a request based on the type of work being performed and the level of confidence required.

This allows the platform to use smaller or local models for routine work while escalating complex, ambiguous, or high-risk work to stronger models when needed.

## **Routing Objective** {#routing-objective}

The goal of model routing is to match each task to the most appropriate model tier.

The router should consider:

* Task complexity.  
* Required reasoning depth.  
* Required context length.  
* Need for tool execution.  
* Need for code understanding.  
* Need for structured output.  
* Sensitivity of the data.  
* Latency requirements.  
* Cost constraints.  
* Confidence level of the first response.  
* Whether the task affects system state.

This prevents the platform from overusing expensive or remote models while also avoiding weak responses for tasks that require stronger reasoning.

## **Asymmetric Model Design** {#asymmetric-model-design}

The aMMare architecture assumes that different models have different roles.

A smaller local model may be well suited for:

* Simple classification.  
* Intent detection.  
* Request summarization.  
* Basic question answering.  
* Lightweight code explanation.  
* Log summarization.  
* Routing decisions.  
* Drafting simple responses.  
* Extracting structured fields.  
* Running repetitive support tasks.

A larger or remote model may be better suited for:

* Complex reasoning.  
* Architecture planning.  
* Multi-step troubleshooting.  
* Code generation.  
* Security analysis.  
* Ambiguous requests.  
* Cross-file repository understanding.  
* Explaining failures.  
* Generating implementation plans.  
* Reviewing diffs.  
* Producing final user-facing summaries.

This approach allows the platform to use each model where it is strongest.

## **Primary Routing Layer** {#primary-routing-layer}

The primary routing layer receives the user request and determines the initial model path.

The router may be implemented as part of the LangChain Agent Middleware Layer or as a separate service in front of the model endpoints. In either case, the routing function should be policy-controlled and observable.

The router should evaluate the request before execution begins.

Example routing inputs include:

* User prompt.  
* Session context.  
* Available tools.  
* Requested operation.  
* Workspace metadata.  
* Data sensitivity.  
* Current safety profile.  
* Prior model response quality.  
* Tool results from earlier workflow steps.

The router should return a structured routing decision rather than relying on informal prompt behavior alone.

## **Example Model Tiers** {#example-model-tiers}

The platform may define model tiers rather than binding the architecture to specific model names.

Example tiers include:

* Local lightweight model.  
* Local coding model.  
* Local reasoning model.  
* Remote general-purpose model.  
* Remote high-reasoning model.  
* Specialized embedding model.  
* Specialized reranking model.  
* Specialized vision model.  
* Specialized speech or transcription model.

The actual model assigned to each tier can change over time as models improve or deployment constraints change.

This keeps the architecture flexible and avoids hard-coding aMMare to one model vendor, one local runtime, or one API provider.

## **Local-First Routing** {#local-first-routing}

The default routing strategy should prefer local models when they are sufficient for the task.

Local-first routing provides several advantages:

* Lower operating cost.  
* Lower latency for small tasks (ideally, target system spec dependent)  
* Reduced dependency on external services.  
* Better control over local data.  
* Better offline or degraded-mode behavior.  
* More predictable infrastructure behavior in a lab environment.

However, local-first does not mean local-only.

If the local model is unlikely to complete the task safely or accurately, the workflow should escalate to a stronger model tier.

## **Escalation Triggers** {#escalation-triggers}

Escalation should occur when the platform detects that the current model tier is insufficient for the task.

Escalation triggers may include:

* Low model confidence.  
* Repeated failed tool calls.  
* Failed validation.  
* Ambiguous user intent.  
* Complex multi-step reasoning.  
* Cross-file code analysis.  
* Security-sensitive changes.  
* Infrastructure-impacting changes.  
* User-visible production changes.  
* Requests involving unfamiliar frameworks.  
* Large context requirements.  
* Need for stronger code review.  
* Need for policy interpretation.  
* Need for final answer verification.

Escalation may also be requested by the model itself, but the middleware should decide whether escalation is allowed.

The model should not be trusted as the sole authority on whether it needs escalation.

## **Confidence-Based Escalation** {#confidence-based-escalation}

The router should support confidence-based escalation.

A model response may be considered low confidence when it contains:

* Uncertainty about the requested task.  
* Incomplete reasoning.  
* Contradictory claims.  
* Unsupported assumptions.  
* Invalid tool requests.  
* Repeated corrections.  
* Failed tests.  
* Output that does not match the requested schema.  
* A result that conflicts with observed tool output.

When confidence is low, the middleware may reroute the task to a stronger model or request human clarification.

Confidence should be based on observable signals where possible, not only on the model’s self-reported confidence.

## **Tool-Aware Routing** {#tool-aware-routing}

Routing should account for the tools required by the task.

Some models may be allowed to use only read-only tools. Other models may be allowed to propose write actions but not execute them. Stronger or more trusted model tiers may be allowed to participate in workflows that involve code edits, patch review, or infrastructure planning.

The tool execution policy remains enforced by the middleware regardless of which model is selected.

Model routing should not bypass tool safety policy.

A stronger model may produce a better plan, but it should still operate through the same approval gates, file restrictions, network restrictions, and audit logging controls.

## **State-Aware Routing** {#state-aware-routing}

The router should consider the current workflow state.

For example, the initial request may be simple enough for a local lightweight model, but later tool output may reveal that the task is more complex. At that point, the middleware can escalate.

Examples include:

* A simple error message expands into a multi-service troubleshooting workflow.  
* A file edit requires understanding multiple related configuration files.  
* A failed test reveals a deeper logic problem.  
* A deployment script change affects container runtime behavior.  
* A log summary reveals security-sensitive findings.  
* A documentation update becomes an architecture design task.

Routing should therefore be available throughout the workflow, not only at the first prompt.

## **Task Classification** {#task-classification}

The router should classify tasks before selecting a model.

Possible task classes include:

* General question.  
* Documentation generation.  
* Code explanation.  
* Code generation/modification.  
* Test generation.  
* Test execution.  
* Script execution and output analysis  
* Log analysis.  
* Configuration review.  
* Infrastructure planning.  
* Security review.  
* Repository maintenance.  
* Troubleshooting.  
* Data extraction.  
* Summarization.  
* Final response generation.

Each task class can map to a preferred model tier, tool profile, and escalation rule.

For example, simple summarization may use a local lightweight model. Repository-wide code modification may start with a local coding model but require escalation to a stronger reasoning model if validation fails.

## **Risk-Based Routing** {#risk-based-routing}

The routing strategy should account for operational risk.

Higher-risk tasks should be routed to stronger models and stricter safety profiles.

Examples of higher-risk tasks include:

* Security configuration changes.  
* Authentication or authorization changes.  
* Firewall changes.  
* Container runtime changes.  
* CI/CD pipeline changes.  
* Infrastructure automation changes.  
* Data deletion.  
* Git history modification.  
* External API calls.  
* Production or shared-environment changes.

For high-risk tasks, the platform may require:

* Stronger model tier.  
* Human approval.  
* Read-only inspection before modification.  
* Validation before final response.  
* Diff review.  
* Audit logging.  
* Explicit rollback notes.

This ensures that routing decisions account for consequences, not only prompt complexity.

## **Cost and Latency Controls** {#cost-and-latency-controls}

Routing should balance answer quality with cost and latency.

The platform should avoid sending every request to the largest available model. Large models should be reserved for cases where their added reasoning quality is likely to matter.

Cost and latency controls may include:

* Local-first defaults.  
* Token budget limits.  
* Maximum context size per model tier.  
* Escalation only after observable need.  
* Use of summarization before escalation.  
* Use of embeddings and retrieval to reduce context size.  
* Caching for repeated queries.  
* Model selection based on expected output size.  
* Timeouts for slow model responses.

The purpose is not to minimize cost at all times. The purpose is to spend cost where it improves correctness, safety, or user value.

## **Context Preparation Before Escalation** {#context-preparation-before-escalation}

Before escalating to a stronger model, the middleware should prepare a compact context package.

The stronger model should receive the information needed to continue the task without receiving unnecessary raw data.

The context package may include:

* Original user request.  
* Current task classification.  
* Current workflow state.  
* Relevant file excerpts.  
* Tool results.  
* Error messages.  
* Failed validation output.  
* Current plan.  
* Prior model response.  
* Safety constraints.  
* Required output format.  
* Open questions or unresolved risks.

This keeps escalation efficient and reduces the chance of leaking irrelevant or sensitive information.

## **De-Escalation** {#de-escalation}

The router should also support de-escalation.

After a complex issue has been resolved or a plan has been produced by a stronger model, routine follow-up work may return to a smaller local model.

Examples of de-escalation include:

* Formatting a final summary.  
* Updating simple documentation.  
* Running a known validation command.  
* Extracting fields from tool output.  
* Summarizing a completed diff.  
* Producing a short user-facing status update.

De-escalation helps preserve resources while keeping high-reasoning models focused on the parts of the workflow where they are most useful.

## **Multi-Model Review** {#multi-model-review}

For certain workflows, aMMare may use more than one model to review the same output.

Multi-model review may be useful for:

* Security-sensitive changes.  
* Large code modifications.  
* Architecture documents.  
* Complex troubleshooting plans.  
* Generated deployment scripts.  
* Policy-sensitive recommendations.  
* Final review before commit or push.

One model may generate a plan or patch, while another model reviews it for correctness, safety, completeness, and policy alignment.

The middleware should treat multi-model review as an advisory process. Final execution authority remains with the middleware and the user approval process.

## **Fallback Behavior** {#fallback-behavior}

The routing layer should define fallback behavior when a model is unavailable.

Fallback conditions may include:

* Local model endpoint unavailable.  
* Remote API unavailable.  
* Model timeout.  
* Rate limit.  
* Authentication failure.  
* Context window exceeded.  
* Unsupported input type.  
* Tool compatibility issue.

Fallback options may include:

* Retry the same model.  
* Route to another local model.  
* Route to a remote model.  
* Reduce context size and retry.  
* Switch to read-only mode.  
* Stop and ask for human direction.  
* Return a partial result with a clear limitation.

Fallback behavior should be predictable and logged.

## **Routing Decision Logging** {#routing-decision-logging}

Every routing decision should be logged.

Routing logs should capture:

* Timestamp.  
* Session identifier.  
* Task classification.  
* Selected model tier.  
* Selected model endpoint.  
* Reason for selection.  
* Escalation trigger, if applicable.  
* De-escalation trigger, if applicable.  
* Safety profile.  
* Tool profile.  
* Token estimate.  
* Latency result.  
* Failure or fallback behavior.

These logs help tune the router over time and explain why a specific model was used for a specific task.

## **Policy-Driven Routing** {#policy-driven-routing}

Routing should be controlled by policy, not only by prompt instructions.

A routing policy may define:

* Which models are available.  
* Which model tiers are allowed for each task class.  
* Which data types may be sent to remote models.  
* Which models may participate in tool workflows.  
* Which tasks require escalation.  
* Which tasks require human approval.  
* Which tasks must remain local.  
* Which fallback paths are allowed.  
* Which logging fields are required.

This makes routing behavior consistent, auditable, and adjustable without rewriting the whole application.

## **Example Routing Flow** {#example-routing-flow}

A typical routing flow may work as follows:

* The user submits a request.  
* The middleware classifies the task.  
* The router selects an initial model tier.  
* The selected model produces a response, plan, or tool request.  
* The middleware validates any requested tool action.  
* Tool results are returned to the model.  
* The middleware evaluates confidence, validation results, and risk.  
* If needed, the task escalates to a stronger model.  
* If the task becomes routine, it de-escalates to a smaller model.  
* The final response is generated.  
* Routing and tool activity are logged.

This flow allows aMMare to adapt during the task instead of making a single static model choice at the beginning.

## **Summary** {#summary-1}

The aMMare model-routing strategy is based on asymmetric use of model capabilities.

Smaller and local models handle routine, low-risk, and repetitive work. Stronger models are reserved for complex reasoning, high-risk changes, large context requirements, code review, security review, and final verification. Routing decisions are based on task class, risk, confidence, tool needs, context size, cost, latency, and policy.

Escalation and de-escalation allow the system to adapt as the workflow develops. The middleware remains responsible for policy enforcement, tool safety, logging, and final execution control regardless of which model is selected.

# **Development and Deployment Roadmap** {#development-and-deployment-roadmap}

The aMMare platform should be developed and deployed in controlled phases.

The initial implementation should start with the smallest useful service chain, validate that chain, and then add additional components only after the previous layer is working. This phased approach reduces troubleshooting complexity and prevents the project from becoming difficult to debug during early development.

The roadmap should be treated as both a development plan and a deployment plan. Each phase should produce a working system state, even if that state is not the final architecture.

The coding agent should not attempt to build the entire platform in one pass.

## **Roadmap Principles** {#roadmap-principles}

The development process should follow these principles:

* Build one layer at a time.  
* Validate each layer before adding the next one.  
* Avoid hardcoding service relationships that will change later.  
* Use stable logical endpoint names from the beginning.  
* Keep each component independently deployable where practical.  
* Keep deployment scripts idempotent.  
* Keep configuration externalized.  
* Document every component as it is added.  
* Add troubleshooting scripts alongside each service.  
* Prefer simple working behavior before advanced routing behavior.  
* Avoid introducing memory, retrieval, or multi-agent behavior until the core model path is stable.

The goal is not only to reach the final architecture. The goal is to create a system that remains understandable and maintainable while it grows.

## **Phase Zero: Repository Scaffold and Baseline Standards** {#phase-zero:-repository-scaffold-and-baseline-standards}

The first phase establishes the project structure, standards, and baseline automation.

This phase should not focus on model behavior yet. It should focus on making sure the repository has a clean structure that future phases can build on.

Required outcomes:

* Create the base repository structure.  
* Create top-level **README.md.**  
* Create **docs**/ directory.  
* Create **scripts**/ directory.  
* Create **config**/ directory.  
* Create **env**/ directory for environment examples.  
* Create **containers/ directory** for service definitions.  
* Create **tests**/ directory.  
* Add baseline linting and formatting standards (pre-commit, rules.md)  
* Add shell script style expectations.   
* Add example environment files.  
* Add basic preflight validation script.  
* Add basic project health script.  
* Add placeholder documentation for future components.  
* Add .gitignore and ensure all \*.env files, which configure IPs or contain secrets, are ignored by git; only the \*.env.example templates are committed  
* Any \<component\>.env file created should have a corresponding \<component\>.env.example template that is included in the repo and is updated with any and all parameters that the end user will need to include in the \<component\>.env file  
* All .env files and templates should be well documented with inline comments

The coding agent should avoid implementing advanced logic in this phase, however the coding agent should be aware of the entire architecture and implementation plan. The purpose is to prepare the project so later changes have a consistent location and naming model.

Expected validation:

* Repository structure exists.  
* Basic scripts run without syntax errors.  
* Example environment files are present.  
* Documentation placeholders are present.  
* No secrets are committed.  
* Git status is clean after generated files are reviewed.

## **Phase One: Local LLM Endpoint** {#phase-one:-local-llm-endpoint}

This phase deploys the first local model endpoint. The agent can use the following repo as reference \- [https://github.com/christopherpaquin/vllm-local-developer-stack](https://github.com/christopherpaquin/vllm-local-developer-stack)

The local model endpoint provides the first usable model backend for the platform. This may be implemented with **vLLM** or another local inference runtime selected for the initial build. Initial POC environment has 2x GPUs so multi-GPU tensor parallelism is required.

At this stage, the model endpoint does not need advanced routing. It only needs to expose a predictable API that can be validated by simple test requests.

Required outcomes:

* Deploy the local LLM container.  
* Select Appropriate model for the target environment (POC will have 2x NVIDIA RTX 3060 GPUs with 24 GB of VRAM total across both GPUs)  
* Define the local model service name.  
* Define the local model listening port.  
* Define model storage paths.  
* Define GPU visibility and runtime requirements.  
* Define local model environment variables.  
* Create a local model deployment script.  
* Create a local model validation script.  
* Create basic request/response smoke test.  
* Document how to change the local model.  
* Document how to view logs.  
* Document common startup failures.  
* Ensure that the LLM container starts at boot  
* Ensure that all documentation related to the operation, endpoints, unit tests, and helper scripts are developed. 

The endpoint should be exposed through a configurable logical model gateway variable.

This value may be a **local IP address, an internal DNS name, a container service name, or a reverse-proxy** name depending on the deployment model. For the initial local lab deployment, using a static local IP address is acceptable.

An important design requirement is that LangChain must not hardcode a direct dependency on a specific model backend. LangChain should read the model gateway endpoint from configuration so the backend can later change from direct local model access to LiteLLM, Headroom or another routing layer without requiring application code changes.

Example logical target using a container or internal DNS name:

| AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-litellm:4000 |
| :---- |

Example logical target using a local lab IP address:

| AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:4000 |
| :---- |

In early phases of the POC, this endpoint may point directly to the local LLM service. In later phases, the same variable can be repointed to LiteLLM, Headroom, or another model gateway component.

This allows the service chain to evolve from:

| LangChain → Local LLM |
| :---- |

to:

| LangChain → LiteLLM → Local LLM / Cloud LLM |
| :---- |

and later to:

| LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

Without requiring LangChain logic to be rewritten each time the backend service chain changes.

Expected validation:

* Local model container starts.  
* GPU is visible to the container if required.  
* Model loads successfully.  
* Healthy endpoint responds.  
* Basic inference request succeeds.  
* Logs show no fatal startup errors.  
* Validation script returns success.

## **Phase Two: LangChain Middleware Layer** {#phase-two:-langchain-middleware-layer}

This phase introduces the **LangChain** middleware service.

The LangChain layer becomes the main orchestration point for user requests, prompt construction, routing decisions, tool-use requests, and workflow state. In early phases, its behavior should remain simple.

The first version should prove that LangChain can receive a request, call the local model endpoint, and return a response.

Required outcomes:

* Deploy LangChain middleware container.  
* Define LangChain service name.  
* Define LangChain listening port.  
* Configure LangChain to use the logical model gateway URL.  
* Add a simple request API.  
* Add basic prompt template handling.  
* Add basic structured logging.  
* Add a health endpoint.  
* Add validation script.  
* Add documentation for modifying LangChain prompts and rules.  
* Add documentation for troubleshooting LangChain-to-model communication.

The LangChain service should not be tightly coupled to a specific local model endpoint. It should rely on configuration.

Expected validation:

* LangChain container starts.  
* LangChain health endpoint responds.  
* LangChain can reach the configured model endpoint.  
* Simple prompt request succeeds.  
* Failed model calls return clear errors.  
* Logs identify the model endpoint being used.  
* Validation script confirms LangChain-to-model path.

## **Phase Three: Direct Local Model Workflow Validation** {#phase-three:-direct-local-model-workflow-validation}

This phase validates the simplest useful service chain.

The chain at this stage is:

| User/API Client → LangChain Middleware → Local LLM Endpoint |
| :---- |

The purpose of this phase is to prove the core request path before introducing additional routing or model gateway complexity.

Required outcomes:

* End-to-end request path works.  
* LangChain can send prompts to the local model.  
* Responses return to the user or API client.  
* Basic error handling works.  
* Service logs are useful for troubleshooting.  
* Endpoint validation script confirms the full chain.  
* Documentation describes the current direct service chain.  
* Known limitations are documented.

Expected validation:

* End-to-end smoke test passes.  
* Invalid request returns controlled error.  
* Stopped model endpoint produces clear LangChain error.  
* Restarted model endpoint recovers without manual reconfiguration.  
* Logs show request path clearly.  
* No cloud model or external dependency is required.

This phase establishes the minimum viable aMMare service path.

## **Phase Four: LiteLLM Routing Layer** {#phase-four:-litellm-routing-layer}

This phase introduces LiteLLM as the model routing layer.

LiteLLM should become the model gateway between LangChain and one or more model providers. Initially, it may route only to the local model endpoint. The purpose is to introduce the routing abstraction before adding additional model providers.

The service chain becomes:

| User/API Client → LangChain Middleware → LiteLLM → Local LLM Endpoint |
| :---- |

Required outcomes:

* Deploy LiteLLM container.  
* Define LiteLLM service name.  
* Define LiteLLM listening port.  
* Configure LiteLLM with local model backend.  
* Repoint LangChain from direct local model access to LiteLLM.  
* Preserve the same logical model gateway variable where possible.  
* Add LiteLLM health check.  
* Add LiteLLM routing validation script.  
* Add documentation for adding and modifying LiteLLM model backends.  
* Add troubleshooting documentation for LiteLLM-to-model failures.

This phase is important because it prevents LangChain from becoming responsible for every model provider connection directly.

Expected validation:

* LiteLLM container starts.  
* LiteLLM can reach the local model backend.  
* LangChain can reach LiteLLM.  
* End-to-end request succeeds through LiteLLM.  
* LiteLLM logs show backend routing activity.  
* Direct local model access can be tested independently.  
* Service chain validation confirms the new path.

## **Phase Five: Cloud Model Provider Integration** {#phase-five:-cloud-model-provider-integration}

This phase adds the first cloud model provider behind LiteLLM.

The goal is to prove that the system can route to both a local model and a cloud model without changing LangChain’s core request logic.

Required outcomes:

* Add cloud model provider configuration.  
* Store cloud provider settings in external configuration.  
* Store credentials securely outside committed files.  
* Add model alias for the cloud model.  
* Add validation script for cloud provider connectivity.  
* Add documentation for adding additional cloud providers.  
* Add documentation for required LangChain changes, if any.  
* Add policy notes for what data may be sent to cloud models.  
* Add failure behavior for unavailable cloud providers.

Expected validation:

* LiteLLM can reach the local model backend.  
* LiteLLM can reach frontier cloud model backend.  
* A request can be routed to the local model.  
* A request can be routed to the frontier cloud model.  
* Missing or invalid cloud credentials produce clear errors.  
* LangChain does not require major code changes to use the new backend.  
* Documentation explains how to add another provider.


| ❗WARNING:  Cloud credentials/APIs are secrets and should never be committed to git and should only exist locally on the target system |
| :---- |


This phase should not yet attempt advanced automated escalation. It should first prove that multiple backends are reachable and selectable.

## **Phase Six: Routing and Escalation Logic** {#phase-six:-routing-and-escalation-logic}

This phase implements the model routing and escalation strategy.

The system should begin making controlled routing decisions based on task type, risk level, confidence, context size, and configured policy. Routing should remain observable and explainable, and well documented. 

Required outcomes:

* Define routing policy file.  
* Define model tiers or aliases.  
* Add task classification logic.  
* Add local-first routing behavior.  
* Add escalation triggers.  
* Add fallback behavior.  
* Add routing decision logs.  
* Add routing validation tests.  
* Add documentation for modifying routing rules.  
* Add examples of simple, medium, and escalated requests.

The routing logic should remain configuration-driven where possible. The coding agent should avoid burying routing rules deep inside application code if they are likely to change. Whenever possible, helper-scripts should provide the end user a standardized way to add/modify/delete/validate routing logic. Helper scripts should exist in a service specific script directory under /scripts in the base repo

Expected validation:

* Simple requests route to the local model.  
* Configured complex requests route to the stronger model.  
* Failed local model requests can fallback or escalate.  
* Routing decisions are logged.  
* Routing policy can be modified without rewriting core code.  
* Validation scripts show which model handled the request.

## **Phase Seven: Headroom Integration** {#phase-seven:-headroom-integration}

This phase introduces Headroom into the service chain.

Headroom should be added only after LangChain, LiteLLM, local model routing, and cloud model routing are working. Adding Headroom earlier would make troubleshooting more difficult because failures could occur across too many layers at once.

The intended service chain may become:

| User/API Client → LangChain Middleware → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

The exact placement of Headroom should be confirmed during implementation. The architecture should preserve enough flexibility to place Headroom where it provides the intended routing, orchestration, or gateway behavior without forcing major rewrites.

Required outcomes:

* Define Headroom role in the service chain.  
* Deploy Headroom container.  
* Define Headroom service name.  
* Define Headroom listening port.  
* Configure upstream and downstream endpoints.  
* Rewire LangChain or gateway configuration as needed.  
* Preserve logical endpoint abstraction.  
* Add Headroom health check.  
* Add service chain validation through Headroom.  
* Add troubleshooting documentation.  
* Document how to bypass Headroom for isolation testing.

Expected validation:

* Headroom container starts.  
* Headroom health endpoint responds.  
* Headroom can reach LiteLLM.  
* LangChain can reach Headroom if Headroom is in the request path.  
* End-to-end request succeeds through the full chain.  
* The previous LiteLLM path can still be validated independently.  
* Logs identify where requests are passing or failing.

This phase should be treated as a controlled service-chain rewiring event.

## **Phase Eight: OpenHands Integration** {#phase-eight:-openhands-integration}

This phase introduces OpenHands or a similar coding-agent workspace component.

OpenHands should not be introduced until the core model routing path is stable. It adds a new level of agentic behavior and may require workspace mounts, tool execution boundaries, and additional security controls.

Required outcomes:

* Define OpenHands role in the architecture.  
* Define whether OpenHands is user-facing, middleware-facing, or task-specific.  
* Deploy OpenHands container.  
* Define workspace mount model.  
* Define access boundaries.  
* Define allowed repositories or project paths.  
* Define relationship to LangChain middleware.  
* Define relationship to model routing layer.  
* Add OpenHands health check.  
* Add basic coding-agent workflow validation.  
* Add documentation for safe workspace usage.

Expected validation:

* OpenHands container starts.  
* Workspace mounts are correct.  
* OpenHands can reach the intended model endpoint or middleware layer.  
* OpenHands cannot access unintended host paths.  
* Basic coding-agent workflow succeeds.  
* Logs and artifacts are visible for review.  
* Tool execution restrictions are documented.

This phase should remain conservative. OpenHands should not receive broad host access simply because it is useful for coding tasks.

## **Phase Nine: Memory, Context, and Retrieval** {#phase-nine:-memory,-context,-and-retrieval}

This phase introduces persistent memory, document retrieval, or context indexing.

Memory and retrieval should be added after the core routing path is stable. Adding memory too early can make it harder to distinguish model behavior problems from retrieval quality problems.

Required outcomes:

* Define memory scope.  
* Define what should and should not be stored.  
* Define vector database or retrieval backend if used.  
* Define document ingestion path.  
* Define embedding model.  
* Define retrieval policy.  
* Define context injection rules.  
* Define redaction behavior.  
* Define reset or purge process.  
* Add memory validation script.  
* Add retrieval quality tests.  
* Add documentation for adding documents to retrieval.  
* Add documentation for troubleshooting bad retrieval results.

Expected validation:

* Memory service starts if applicable.  
* Documents can be indexed.  
* Retrieval returns relevant context.  
* Irrelevant context is not over-injected.  
* Sensitive content handling is documented.  
* LangChain can use retrieved context.  
* The system still works when retrieval is disabled.

Memory should be optional during initial deployment.

## **Phase Ten: Full Service Chain Validation** {#phase-ten:-full-service-chain-validation}

This phase validates the complete intended service path.

The final service chain may include:

| User/API Client→ LangChain Middleware→ Headroom→ LiteLLM→ Local LLM and Cloud LLM providers→ Optional memory/retrieval services→ Optional coding-agent workspace |
| :---- |

The exact final chain may vary based on which components are enabled.

Required outcomes:

* Add full service-chain validation script.  
* Add component-by-component validation.  
* Add dependency validation.  
* Add configuration validation.  
* Add model backend validation.  
* Add routing validation.  
* Add memory/retrieval validation if enabled.  
* Add OpenHands validation if enabled.  
* Add failure-mode tests.  
* Add final deployment summary output.

Expected validation:

* Every enabled container is running.  
* Every enabled health endpoint responds.  
* Internal service DNS or hostnames resolve.  
* Config files are valid.  
* Required ports are listening.  
* Required volumes exist.  
* Model backends respond.  
* End-to-end prompt succeeds.  
* Routing behavior matches policy.  
* Optional components can be disabled cleanly.  
* Logs identify the active service path.

This phase should make it easy to determine whether the system is healthy without manually inspecting every container.

## **Phase Eleven: One-Click Modular Deployment** {#phase-eleven:-one-click-modular-deployment}

This phase consolidates earlier deploy scripts into a top-level one-click deployment process.

The one-click deployment script should orchestrate the component deployment scripts. It should not become a large monolithic script containing all logic.

Required outcomes:

* Create top-level deploy script.  
* Create top-level uninstall script.  
* Create top-level validation script.  
* Add component selection flags.  
* Add deployment profiles.  
* Add preflight checks.  
* Add ordered deployment logic.  
* Add post-deployment validation.  
* Add deployment summary.  
* Add failure reporting.  
* Add documentation for deployment profiles.

**Example deployment profiles may include:**

| minimal-locallocal-with\-litellmhybrid-local-cloudfull-agenticfull-agentic-with\-memory |
| :---- |

The deployment configuration should allow users to pick which components to deploy either directly on the cli, or via variable in the global environment file (env/ammare.env)

Expected validation:

* Minimal deployment works.  
* Full deployment works.  
* Optional components can be skipped.  
* Re-running deployment is safe (idempotent)  
* Failed deployment reports the failed component.  
* Validation can be run independently after deployment.  
* Uninstall behavior is documented and controlled.  
* The creation of an uninstall script is imperative in order to allow for easy cleanup after a deployment (failed or successful). As we progress through the deployment phases, the uninstall script should allow the environment to be wiped clean in order to test deployment in a new environment minus any remaining deployment artifacts. 

The top-level script should preserve modularity.

## **Phase Twelve: Documentation, Hardening, and Release Packaging** {#phase-twelve:-documentation,-hardening,-and-release-packaging}

This phase prepares the project for repeatable use.

By this point, the system should already work. This phase focuses on making it understandable, maintainable, and safer for future modification.

Required outcomes:

* Complete top-level README.md.  
* Complete component documentation.  
* Complete deployment documentation.  
* Complete configuration documentation.  
* Complete troubleshooting documentation.  
* Complete validation documentation.  
* Complete coding-agent implementation guide.  
* Review security-sensitive defaults.  
* Review secret handling.  
* Review container permissions.  
* Review exposed ports.  
* Review logging behavior.  
* Review failure behavior.  
* Add release checklist.  
* Add known limitations.  
* Add deferred features list.

Expected validation:

* A new user can understand the architecture from the README.  
* A coding agent can follow the implementation guide.  
* Each component has modification instructions.  
* Each component has validation instructions.  
* Troubleshooting scripts are documented.  
* No secrets are committed.  
* Default deployment is conservative.  
* Final service-chain validation passes.

The aMMare development and deployment roadmap is intentionally phased.

The project should begin with a simple local model endpoint and LangChain middleware path. After that path is validated, LiteLLM can be added as the routing layer, followed by cloud model providers, escalation logic, Headroom, OpenHands, memory, and full-chain validation.

This phased approach provides a clear path to the final architecture while reducing early troubleshooting complexity. It also gives both the end user and the coding agent a practical roadmap for building, validating, documenting, and operating the system incrementally.

Detailed implementation expectations for the coding agent, including work patterns, configuration rules, validation requirements, and stop conditions, are defined in the Coding Agent Implementation Guide chapter later in this document.

# **Target Service Topology** {#target-service-topology}

The aMMare platform should define the intended service topology before all components are implemented.

The initial deployment may start with only a local model endpoint and LangChain middleware, but the architecture should still describe the final expected service layout. This gives the coding agent a clear target and prevents early implementation choices from making later service-chain changes more difficult.

The topology described in this section should be treated as the intended end state. Individual deployment phases may enable only a subset of these services.

## **Topology Principles** {#topology-principles}

The service topology should follow these principles:

* Each major function should run as a separate containerized service.  
* Each service should have a predictable name.  
* Each service should have clearly documented listening ports.  
* Internal service relationships should be configured through environment variables or config files.  
* Direct hardcoded service URLs should be avoided inside application code.  
* Optional services should be disabled cleanly when not deployed.  
* Each service should have a health check.  
* Each service should write logs to a predictable location.  
* Each service should have its own documentation.  
* The full service chain should be testable end to end.  
* Each layer should be independently testable for troubleshooting.  
* Each service should have non-ephemeral storage (when storage is required)  
* Each service should start automatically on boot  
* NOTE: Additional consideration regarding startup order may be required depending on service behavior or dependencies

The topology should support both a minimal local deployment and a more complete multi-service deployment.

## **Target Service Chain** {#target-service-chain}

The final intended service chain may include the following path:

| User/API Client→ LangChain Middleware→ Headroom→ LiteLLM→ Local LLM and Cloud LLM Providers |
| :---- |

Optional supporting services may include:

| Memory / Retrieval BackendEmbedding ModelVector DatabaseOpenHands / Coding Agent WorkspaceManagement and Validation Scripts |
| :---- |

The exact request path may vary depending on which deployment profile is enabled.

A minimal deployment may use:

| User/API Client→ LangChain Middleware→ Local LLM Endpoint |
| :---- |

A local routing deployment may use:

| User/API Client→ LangChain Middleware→ LiteLLM→ Local LLM Endpoint |
| :---- |

A hybrid deployment may use:

| User/API Client→ LangChain Middleware→ LiteLLM→ Local LLM Endpoint / Cloud Model Provider |
| :---- |

A full deployment may use:

| User/API Client→ LangChain Middleware→ Headroom→ LiteLLM→ Local LLM Endpoint / Cloud Model Provider |
| :---- |

The topology should allow these modes without requiring major application rewrites.

## **Logical Endpoint Strategy** {#logical-endpoint-strategy}

Services should communicate through configurable logical endpoints.

A logical endpoint is a configuration value that points to the current target service. It may use a static local IP address, an internal DNS name, a container service name, or a reverse-proxy address.

For the local lab deployment, static local IP addresses are acceptable. The important requirement is that service targets are defined in configuration rather than hardcoded into application logic. Some services/containers will need LAN local IP addresses so that external users or tools may connect over the network leverage the stack, however many components will only need system local ip addresses and may not need an IP/port exposed to the LAN

Example using a local lab IP address:

| AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:4000 |
| :---- |

Example using an internal service name:

| AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-litellm:4000 |
| :---- |

In an early deployment, this endpoint may point directly to the local LLM service. In later deployments, it may point to LiteLLM or Headroom.

This allows the backend service chain to change while preserving the same application-level configuration pattern.

## 

## 

## **Proposed Service Inventory** {#proposed-service-inventory}

The following service inventory describes the intended full topology.

| Service | Purpose | Required Initially | Typical Port | Notes |
| ----- | ----- | ----- | ----- | ----- |
| ammare-langchain | Main middleware and orchestration layer | Yes | 8080 | Receives user/API requests and coordinates model/tool workflows. |
| ammare-local-llm | Local model inference endpoint | Yes | 8000 | Initial local model runtime, such as vLLM or similar. |
| ammare-litellm | Model routing layer | No | 4000 | Routes requests to local and cloud model providers. |
| ammare-headroom | Additional gateway/orchestration layer | No | 4100 | Added after core model routing is validated. |
| ammare-openhands | Coding-agent workspace service | No | TBD | Optional agentic coding environment. |
| ammare-vector-db | Vector storage for retrieval | No | TBD | Optional memory/retrieval backend. |
| ammare-embedding | Local embedding model endpoint | No | TBD | Optional service for document indexing and retrieval. |
| ammare-ui | Optional web UI or front-end | No | TBD | May be deferred depending on initial scope. |

Ports marked **TBD** should be finalized during implementation and then updated in this document and the deployment documentation.

The coding agent should not invent hidden service names or undocumented ports. If a new service or port is required, it should update this topology section and the related documentation.

## **Required Initial Services** {#required-initial-services}

The minimum viable deployment should include:

| ammare-langchainammare-local-llm |
| :---- |

This supports the earliest working service chain:

| User/API Client:→ ammare-langchain→ ammare-local-llm |
| :---- |

This initial topology is intentionally simple. It validates that the middleware can reach a local model endpoint and return a response.

The initial deployment should still use a logical model gateway variable so the backend target can be changed later.

## **Optional Services** {#optional-services}

Optional services should be enabled through deployment configuration.

Optional components may include:

* LiteLLM.  
* Headroom.  
* OpenHands.  
* Memory backend.  
* Vector database.  
* Embedding model.  
* UI layer.  
* Additional model providers.  
* Additional management or observability components.

Optional services should not be required for the minimal local deployment.

If an optional service is disabled, dependent services should either bypass it cleanly or fail with a clear configuration error.

## **Service Naming Standard** {#service-naming-standard}

Service names should be predictable and consistent.

Recommended naming pattern:

| ammare-\<component\> |
| :---- |

Examples:

| ammare-langchainammare-local-llmammare-litellmammare-headroomammare-openhandsammare-vector-dbammare-embedding |
| :---- |

Scripts, documentation, directories, environment variables, logs, and health checks should use these names consistently.

If the project later supports multiple instances of the same service type, the name should include a role or instance suffix.

Example:

| ammare-local-llm-primaryammare-local-llm-secondaryammare-embedding-smallammare-embedding-large |
| :---- |

## **Port Management** {#port-management}

All service ports should be documented.

The project should maintain a central port table in the deployment documentation and, ideally, in a machine-readable configuration file.

The following endpoint and port reference table is the authoritative list of service endpoints, default ports, and network exposure. For the initial POC, the deployment host is 10.1.10.17 on the 10.1.10.0/24 lab subnet; this address is a POC-specific reference only. Only the client-facing gateway endpoint (ammare-langchain) needs to be reachable from anywhere on the LAN subnet, because it is the endpoint that IDE and CLI clients connect to. All other services should bind only to host-local or container-internal networks and should not be published to the LAN.

| Service | Default Port | Example Endpoint | Network Exposure |
| :---- | :---- | :---- | :---- |
| ammare-langchain | 8080 | http://10.1.10.17:8080 | LAN-routable (10.1.10.0/24). Client-facing gateway; IDE/CLI clients connect here (AMMARE\_GATEWAY\_URL). |
| ammare-local-llm | 8000 | http://ammare-local-llm:8000 | Internal only (host-local or container network). |
| ammare-litellm | 4000 | http://ammare-litellm:4000 | Internal only (host-local or container network). |
| ammare-headroom | 4100 | http://ammare-headroom:4100 | Internal only (host-local or container network). |
| ammare-openhands | TBD | http://ammare-openhands:TBD | Internal only by default; LAN exposure may be added at implementation if browser access from other machines is required. |
| ammare-vector-db | TBD | http://ammare-vector-db:TBD | Internal only (host-local or container network). |
| ammare-embedding | TBD | http://ammare-embedding:TBD | Internal only (host-local or container network). |
| ammare-ui | TBD | http://ammare-ui:TBD | Internal only by default; LAN exposure may be added at implementation if deployed for browser access. |

The topology should distinguish between:

* Container internal ports.  
* Host-published ports.  
* Local-only ports.  
* API ports.  
* Health-check ports.  
* Optional UI ports.

For local lab deployments, it is acceptable for services to bind to local lab IP addresses. Services that do not need external access should not be published beyond the host or internal container network.

The coding agent should avoid randomly selecting ports during implementation. New ports should be added deliberately and documented.

## **Network Model** {#network-model}

The platform should support a local lab network model.

The initial deployment may use a single host with multiple containers. Later deployments may spread services across multiple hosts if required by GPU placement, resource constraints, or testing goals.

Supported network patterns may include:

* Single host with container-internal networking.  
* Single host with selected host-published ports.  
* Local lab IP-based service access.  
* Internal DNS or static hostname mapping.  
* Multi-host deployment using static IPs or local DNS.

**The architecture should not assume public internet exposure.**

Cloud model providers may require outbound internet access, but inbound public access should not be required for the core local platform.

## **Shared Configuration Paths** {#shared-configuration-paths}

The deployment should use predictable configuration paths.

Recommended project-level paths:

| config/env/scripts/docs/tests/logs/data/models/ (reference only, models should not be committed to git) |
| :---- |

Recommended component-specific configuration paths:

| config/langchain/config/litellm/config/headroom/config/local-llm/config/openhands/config/memory/ |
| :---- |

Recommended environment template file paths:

| env/ammare.env.example env/langchain.env.exampleenv/local-llm.env.exampleenv/litellm.env.exampleenv/headroom.env.exampleenv/openhands.env.exampleenv/memory.env.example |
| :---- |

Recommended environment file paths (git ignored)

| env/ammare.env env/langchain.envenv/local-llm.envenv/litellm.envenv/headroom.envenv/openhands.envenv/memory.env |
| :---- |

Actual environment files above that contain local values or secrets should not be committed, use the environment template files as examples and include them in repo commits

Note: All env files need to be well documented with inline comments explaining the usage of each defined variable. 

Environment files are not hidden files. Actual environment files use the plain \<component\>.env naming convention and are excluded from version control through .gitignore, while the corresponding \<component\>.env.example templates are committed to the repository.

## **Shared Runtime Paths** {#shared-runtime-paths}

Runtime data should be separated from static configuration.

Recommended runtime paths:

| data/models/data/vector-db/data/openhands-workspaces/data/uploads/logs/tmp/ |
| :---- |

These paths should be documented so users know what persists across restarts and what can be safely removed.

The coding agent should not scatter persistent data into undocumented directories.

## **Environment Variable Standards** {#environment-variable-standards}

Environment variables should use a consistent prefix.

Recommended global prefix:

| AMMARE\_ |
| :---- |

Examples:

| AMMARE\_MODEL\_GATEWAY\_URL=AMMARE\_LANGCHAIN\_PORT=AMMARE\_LITELLM\_PORT=AMMARE\_LOCAL\_LLM\_PORT=AMMARE\_HEADROOM\_PORT=AMMARE\_DEPLOY\_PROFILE=AMMARE\_ENABLE\_LITELLM=AMMARE\_ENABLE\_HEADROOM=AMMARE\_ENABLE\_OPENHANDS=AMMARE\_ENABLE\_MEMORY= |
| :---- |

Component-specific variables may use the same prefix plus the component name.

Examples:

| AMMARE\_LANGCHAIN\_LOG\_LEVEL=AMMARE\_LITELLM\_CONFIG\_PATH=AMMARE\_LOCAL\_LLM\_MODEL\_PATH=AMMARE\_LOCAL\_LLM\_GPU\_DEVICES=AMMARE\_HEADROOM\_UPSTREAM\_URL= |
| :---- |

Two gateway variables are intentionally distinct and must not be conflated: **AMMARE\_GATEWAY\_URL** is the client-facing endpoint that IDE, CLI, and other end-user tools connect to (the ammare-langchain service, default port 8080), while **AMMARE\_MODEL\_GATEWAY\_URL** is the internal downstream model gateway that the LangChain middleware sends model requests to (the local LLM endpoint, ammare-litellm, or ammare-headroom, depending on the active service chain).

The coding agent should prefer clear environment variables over hardcoded values.

All variables above should be created with a default value. End users can modify as needed. 

## **Startup Order** {#startup-order}

The deployment should start services in dependency order.

**A typical full startup order may be:**

| Local LLM EndpointLiteLLMHeadroomMemory / Retrieval ServicesOpenHandsLangChain MiddlewareOptional UI |
| :---- |

However, the exact order may vary depending on the enabled deployment profile.

The deployment scripts should validate each dependency before starting dependent services where practical.

For example:

* LiteLLM should validate that at least one model backend is configured.  
* Headroom should validate that its upstream endpoint is reachable.  
* LangChain should validate that its configured model gateway is reachable.  
* OpenHands should validate that its workspace path exists.  
* Memory services should validate that the vector database is available.

## **Independent Troubleshooting Paths** {#independent-troubleshooting-paths}

Each service should be independently testable.

The platform should provide scripts that can validate:

* Local LLM endpoint directly.  
* LiteLLM to local LLM.  
* LiteLLM to cloud provider.  
* Headroom to LiteLLM.  
* LangChain to configured model gateway.  
* Full user-to-model service chain.  
* Memory indexing.  
* Memory retrieval.  
* OpenHands workspace behavior.

This is important because the final chain may contain several layers. A failure in the full chain should be isolated quickly to the failing component.

## **Health Check Standard** {#health-check-standard}

Each service should provide or expose a health check.

Health checks should be lightweight and should not require a full model generation unless specifically testing inference behavior.

Recommended health-check categories:

* Container running.  
* Port listening.  
* HTTP health endpoint responding.  
* Required config file present.  
* Required upstream reachable.  
* Required model loaded.  
* Required volume mounted.  
* Required credentials present if applicable.

The full validation script should combine these individual checks into a service-chain health report.

## **Logging Standard** {#logging-standard}

Each service should write logs in a predictable way.

Logs should support both direct container log inspection and optional file-based collection.

Recommended logging expectations:

* Logs should identify service name.  
* Logs should identify startup configuration summary without exposing secrets.  
* Logs should show upstream endpoint selection.  
* Logs should show request routing decisions where applicable.  
* Logs should show validation failures clearly.  
* Logs should not print API keys or credentials.  
* Logs should be documented for each component.

The troubleshooting documentation should explain where to find logs for each service.

## **Deployment Profiles** {#deployment-profiles}

The topology should support deployment profiles.

Example profiles:

| minimal-locallocal-with\-litellmhybrid-local-cloudfull-agenticfull-agentic-with\-memory |
| :---- |

Each profile should define which services are enabled and how the service chain is connected.

Example:

| Profile | Enabled Services | Request Path |
| ----- | ----- | ----- |
| minimal-local | LangChain, Local LLM | LangChain → Local LLM |
| local-with-litellm | LangChain, LiteLLM, Local LLM | LangChain → LiteLLM → Local LLM |
| hybrid-local-cloud | LangChain, LiteLLM, Local LLM, Cloud Provider | LangChain → LiteLLM → Local / Cloud |
| full-agentic | LangChain, Headroom, LiteLLM, Local LLM, Cloud Provider, OpenHands | LangChain → Headroom → LiteLLM → Models |
| full-agentic-with-memory | LangChain, Headroom, LiteLLM, Models, OpenHands, Memory | LangChain → Headroom → LiteLLM → Models, with retrieval support |

The deployment profile should be selected through configuration or a deployment flag.

## **Topology Update Requirement** {#topology-update-requirement}

This topology section should be updated whenever a service is added, removed, renamed, or rewired.

Changes that require topology updates include:

* New container service.  
* New exposed port.  
* New internal port.  
* New volume mount.  
* New environment file.  
* New upstream dependency.  
* New deployment profile.  
* New health-check endpoint.  
* New model provider.  
* New service-chain path.

The coding agent should treat this section as a source of architectural truth. If implementation requires a topology change, the document should be updated in the same phase as the code change.

## **Summary** {#summary-2}

The aMMare target service topology defines the intended full deployment while still supporting phased implementation.

The initial system may start with only LangChain and a local LLM endpoint. Later phases can add LiteLLM, cloud providers, Headroom, OpenHands, memory, retrieval, and additional operational tooling.

The key design requirement is that service relationships remain configurable. IP addresses are acceptable for the local lab deployment, but service targets should still be expressed through logical configuration variables so the request path can evolve without rewriting core application logic.

# **Component Configuration Model** {#component-configuration-model}

The aMMare platform should use a predictable and centralized configuration model.

Configuration should be externalized wherever practical so services can be added, removed, rewired, or replaced without requiring application code changes. This is especially important because the deployment will evolve across phases from a simple local model path to a more complete routed service chain.

The goal is to keep configuration clear, portable, and easy for both users and coding agents to modify safely.

## **Configuration Principles** {#configuration-principles}

Configuration should follow these principles:

* Avoid hardcoded service URLs in application code.  
* Use environment variables for deployment-specific values.  
* Use config files for structured routing and provider definitions.  
* Keep example configuration files committed.  
* Keep real secrets out of the repository.  
* Validate configuration before deploying services.  
* Keep global settings separate from component-specific settings.  
* Document which files control each service.  
* Use stable variable names even if the underlying service chain changes.

## **Configuration Layout** {#configuration-layout}

The repository should separate global configuration, component configuration, examples, and runtime data.

Recommended layout:

| env/  ammare.env.example  langchain.env.example  local-llm.env.example  litellm.env.example  headroom.env.example  openhands.env.example  memory.env.example |
| :---- |

| config/  models.yaml  routing.yaml  langchain/  local-llm/  litellm/  headroom/  openhands/  memory/ |
| :---- |

The **env/** directory should contain environment variable examples and local deployment values.

The **config/** directory should contain structured configuration files used by services and scripts.

Actual local environment files may be created from the examples but should not be committed if they contain host-specific values or secrets.

## **Global Configuration** {#global-configuration}

Global configuration should define settings shared across the deployment.

**Examples:**

| AMMARE\_DEPLOY\_PROFILE=AMMARE\_BASE\_DIR=AMMARE\_CONFIG\_DIR=AMMARE\_DATA\_DIR=AMMARE\_LOG\_DIR=AMMARE\_ENABLE\_LITELLM=AMMARE\_ENABLE\_HEADROOM=AMMARE\_ENABLE\_OPENHANDS=AMMARE\_ENABLE\_MEMORY=AMMARE\_LOG\_LEVEL= |
| :---- |

Global configuration should describe the active deployment profile and which optional components are enabled.

Component scripts should read these values rather than making independent assumptions about paths, profiles, or enabled services.

## **Component Configuration** {#component-configuration}

Each component should have its own configuration file or environment file.

**Examples:**

| env/langchain.envenv/local-llm.envenv/litellm.envenv/headroom.envenv/openhands.envenv/memory.env |
| :---- |

Each component configuration should define only the values required for that component.

**For example, LangChain configuration may define:**

| AMMARE\_LANGCHAIN\_PORT=AMMARE\_MODEL\_GATEWAY\_URL=AMMARE\_LANGCHAIN\_LOG\_LEVEL=AMMARE\_LANGCHAIN\_RULES\_PATH= |
| :---- |

**Local LLM configuration may define:**

| AMMARE\_LOCAL\_LLM\_PORT=AMMARE\_LOCAL\_LLM\_MODEL\_PATH=AMMARE\_LOCAL\_LLM\_GPU\_DEVICES=AMMARE\_LOCAL\_LLM\_RUNTIME= |
| :---- |

**LiteLLM configuration may define:**

| AMMARE\_LITELLM\_PORT=AMMARE\_LITELLM\_CONFIG\_PATH=AMMARE\_LITELLM\_DEFAULT\_MODEL= |
| :---- |

**Headroom configuration may define:**

| AMMARE\_HEADROOM\_PORT=AMMARE\_HEADROOM\_UPSTREAM\_URL=AMMARE\_HEADROOM\_CONFIG\_PATH= |
| :---- |

The coding agent should not duplicate the same setting across multiple files unless there is a clear reason.

## **Logical Endpoint Configuration** {#logical-endpoint-configuration}

Service-to-service communication should use logical endpoint variables.

The most important example is the model gateway endpoint:

| AMMARE\_MODEL\_GATEWAY\_URL= |
| :---- |

This value may point to a local IP address, a container service name, local DNS, LiteLLM, Headroom, or another model gateway layer.

Examples:

| AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:8000AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:4000AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-litellm:4000AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-headroom:4100 |
| :---- |

The value can change between phases, but LangChain should continue reading the same variable.

This allows the service chain to evolve without rewriting LangChain application logic.

## **Model Endpoint Registry** {#model-endpoint-registry}

Model endpoints should be defined in a structured registry.

Recommended file:

| config/models.yaml |
| :---- |

This file should describe available local and cloud model endpoints.

Example structure:

| models:  local\_default:    type: local    provider: vllm    base\_url: http://10.1.10.17:8000    model: local-model-name    enabled: true  cloud\_default:    type: cloud    provider: openai-compatible    base\_url: https://provider.example.com/v1    model: cloud-model-name    enabled: false |
| :---- |

The registry should store model metadata and endpoint definitions, but it should not store raw API keys.

## **Routing Configuration** {#routing-configuration}

Routing rules should be stored separately from application code where practical.

Recommended file:

| config/routing.yaml |
| :---- |

This file may define:

* Default model.  
* Local-first behavior.  
* Model aliases.  
* Escalation targets.  
* Fallback targets.  
* Task-to-model mappings.  
* Risk-based routing behavior.

Example structure:

| default\_model: local\_defaultrouting:  simple:    model: local\_default  coding:    model: local\_coding    fallback: cloud\_default  high\_reasoning:    model: cloud\_defaultescalation:  enabled: true  fallback\_on\_failure: true |
| :---- |

The routing file should be simple at first and expanded only as routing behavior becomes more advanced.

## **Secrets Handling** {#secrets-handling}

Secrets should be kept separate from committed configuration.

Secrets may include:

* Cloud model API keys.  
* Service tokens.  
* Webhook credentials.  
* Repository credentials.  
* Private endpoints.  
* Authentication tokens.

**Recommended handling:**

| env/secrets.env |
| :---- |

or a deployment-specific secrets mechanism.

Secret files should be excluded from version control.

**Example:**

| OPENAI\_API\_KEY=ANTHROPIC\_API\_KEY=CLOUD\_MODEL\_API\_KEY= |
| :---- |

Application logs, validation scripts, and error messages should not print secret values.

## **Configuration Validation** {#configuration-validation}

The project should include configuration validation scripts.

**Recommended script:**

| scripts/validate-config.sh |
| :---- |

This script should check:

* Required environment files exist.  
* Required variables are set.  
* Enabled services have required configuration.  
* Ports are valid.  
* URLs are valid.  
* Referenced files and directories exist.  
* Model registry entries are valid.  
* Routing rules reference known models.  
* Secret variables are present when cloud providers are enabled.

Configuration validation should run before deployment and as part of the full service validation process.

## **Configuration Ownership** {#configuration-ownership}

Each configuration file should have a clear purpose.

**Suggested ownership:**

| File | Purpose |
| :---- | :---- |
| env/ammare.env | Global deployment settings. |
| env/\<component\>.env | Component-specific environment variables. |
| env/secrets.env | Local secrets, not committed. |
| config/models.yaml | Model endpoint registry. |
| config/routing.yaml | Model routing and escalation rules. |
| config/\<component\>/ | Component-specific structured config. |

The coding agent should update the correct file rather than creating new configuration locations without reason.

## **Summary** {#summary-3}

The aMMare configuration model should keep deployment-specific values, component settings, model definitions, routing rules, and secrets clearly separated.

The most important rule is that service relationships must remain configurable. Local IP addresses are acceptable for the lab deployment, but they should still be assigned through environment variables or structured config files rather than hardcoded into application logic.

# **Service Chaining and Rewiring Strategy** {#service-chaining-and-rewiring-strategy}

The aMMare service chain will evolve over multiple phases.

Early deployments may connect LangChain directly to a local model endpoint. Later deployments may introduce LiteLLM, cloud model providers, Headroom, memory, retrieval, or coding-agent services. The architecture must support these changes without requiring major rewrites to the LangChain layer or deployment scripts.

The goal is to make service chaining intentional, configurable, and testable.

## **Chaining Principle** {#chaining-principle}

Each service should connect to the next layer through configuration, not hardcoded application logic.

A service should not assume that its upstream or downstream target will always be the same component. This is especially important for LangChain, because the model path may change several times during development.

The model path may evolve from:

| LangChain → Local LLM |
| :---- |

to:

| LangChain → LiteLLM → Local LLM |
| :---- |

to:

| LangChain → LiteLLM → Local LLM / Cloud LLM |
| :---- |

to:

| LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

Each transition should be handled by configuration changes and validation scripts whenever practical.

## **Logical Gateway Pattern** {#logical-gateway-pattern}

LangChain should use a logical model gateway endpoint.

**Recommended variable:**

| AMMARE\_MODEL\_GATEWAY\_URL= |
| :---- |

This value should represent the next service in the active model path.

**Examples:**

| AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:8000AMMARE\_MODEL\_GATEWAY\_URL=http://10.1.10.17:4000AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-litellm:4000AMMARE\_MODEL\_GATEWAY\_URL=http://ammare-headroom:4100 |
| :---- |

The value may be a local IP address, local DNS name, container service name, or reverse-proxy name. For the initial lab deployment, static local IPs are acceptable.

The important requirement is that LangChain reads this value from configuration and does not hardcode a specific backend.

## **Phase-Based Chain Evolution** {#phase-based-chain-evolution}

The service chain should change only after the current chain is validated.

**Recommended progression:**

Note: the stages below describe the evolution of the service chain and are numbered independently of the Development and Deployment Roadmap phases.

**Stage 1:**

| LangChain → Local LLM |
| :---- |

**Stage 2:**

| LangChain → LiteLLM → Local LLM |
| :---- |

**Stage 3:**

| LangChain → LiteLLM → Local LLM / Cloud LLM |
| :---- |

**Stage 4:**

| LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

**Stage 5:**

| LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM            ↘ Memory / Retrieval            ↘ OpenHands / Coding Workspace |
| :---- |

The coding agent should not add multiple new chain layers in the same step unless explicitly instructed.

Each phase should include service-specific validation and full-chain validation before moving forward.

## **Rewiring Events** {#rewiring-events}

A rewiring event occurs when one service is inserted, removed, bypassed, or replaced in the request path.

Examples:

* Repointing LangChain from the local LLM to LiteLLM.  
* Repointing LangChain from LiteLLM to Headroom.  
* Adding a cloud model backend to LiteLLM.  
* Temporarily bypassing Headroom for troubleshooting.  
* Disabling memory or retrieval.  
* Replacing a local model endpoint.  
* Moving a service from one host IP to another.

Rewiring should be treated as an intentional change. It should update configuration, documentation, and validation scripts in the same phase.

## **Rewiring Requirements** {#rewiring-requirements}

Each rewiring event should include:

* Updated environment variables.  
* Updated service configuration files.  
* Updated deployment profile if needed.  
* Updated topology documentation.  
* Updated validation script behavior.  
* Updated troubleshooting notes.  
* Confirmation that the previous layer can still be tested independently.  
* Confirmation that the new full chain works end to end.

The coding agent should not silently change service paths without updating the related documentation.

## **Bypass Paths** {#bypass-paths}

The architecture should support bypass paths for troubleshooting.

Bypass paths allow a user to isolate a failing component without dismantling the whole deployment.

Examples:

| LangChain → Local LLM |
| :---- |

| LangChain → LiteLLM → Local LLM |
| :---- |

| LangChain → Headroom → LiteLLM → Local LLM |
| :---- |

| LiteLLM → Local LLM |
| :---- |

| LiteLLM → Cloud LLM |
| :---- |

Each major service should have a direct validation script so failures can be isolated quickly.

Example scripts:

| scripts/test-local-llm.shscripts/test-litellm-local.shscripts/test-litellm-cloud.shscripts/test-headroom.shscripts/test-langchain-gateway.shscripts/test-full-chain.sh |
| :---- |

## **Deployment Profiles** {#deployment-profiles-1}

Deployment profiles should define which chain is active.

**Examples:**

| minimal-locallocal-with\-litellmhybrid-local-cloudfull-agenticfull-agentic-with\-memory |
| :---- |

Each profile should explicitly define:

* Enabled services.  
* Disabled services.  
* LangChain gateway target.  
* Model routing layer.  
* Active model providers.  
* Whether Headroom is in path.  
* Whether memory/retrieval is enabled.  
* Whether OpenHands is enabled.

A deployment profile should make the active chain obvious without requiring users to inspect multiple files.

## **Avoiding Early Hardcoding** {#avoiding-early-hardcoding}

The initial implementation should avoid shortcuts that make later rewiring difficult.

The coding agent should avoid:

* Hardcoding LangChain directly to a local model URL.  
* Embedding provider-specific model names throughout application logic.  
* Duplicating endpoint URLs in multiple scripts.  
* Assuming LiteLLM is always present.  
* Assuming Headroom is always present.  
* Assuming cloud model providers are always available.  
* Assuming memory is always enabled.  
* Assuming all services run on the same host.  
* Selecting undocumented ports.  
* Creating undocumented config files.

Temporary direct connections are acceptable during early phases, but they must still be expressed through configuration.

## **Service Contract Expectations** {#service-contract-expectations}

Each service boundary should have a basic contract.

At minimum, each service should define:

* Input API or request format.  
* Output format.  
* Health-check behavior.  
* Error behavior.  
* Required environment variables.  
* Required upstream services.  
* Expected downstream services.  
* Timeout behavior.  
* Logging behavior.

This helps prevent later components from depending on unclear or accidental behavior.

For example, LangChain should know only that it has a configured model gateway. It should not need to know whether that gateway is the local model endpoint, LiteLLM, or Headroom.

## **Configuration-Driven Chain Selection** {#configuration-driven-chain-selection}

The active service chain should be selected by configuration.

**Recommended variables:**

| AMMARE\_DEPLOY\_PROFILE=AMMARE\_MODEL\_GATEWAY\_URL=AMMARE\_ENABLE\_LITELLM=AMMARE\_ENABLE\_HEADROOM=AMMARE\_ENABLE\_MEMORY=AMMARE\_ENABLE\_OPENHANDS= |
| :---- |

The top-level deployment script should read these values and deploy only the selected services.

Validation scripts should also read the active profile so they test the correct chain.

## **Validation After Rewiring** {#validation-after-rewiring}

Every service-chain change should be validated.

Validation should include:

* Confirm enabled services are running.  
* Confirm required ports are listening.  
* Confirm configured URLs are reachable.  
* Confirm each service can reach its upstream.  
* Confirm each service can reach its downstream.  
* Confirm a test prompt succeeds through the active chain.  
* Confirm logs show the expected path.  
* Confirm disabled services are not required by the active profile.

The validation result should identify where the chain fails if a test does not pass.

## **Failure Isolation** {#failure-isolation}

The service chain should be designed for fast failure isolation.

When a full-chain request fails, the troubleshooting path should move from downstream to upstream:

| Local LLMLiteLLMHeadroomLangChainUser/API Client |
| :---- |

For example:

* Test the local model directly.  
* Test LiteLLM against the local model.  
* Test LiteLLM against any cloud provider.  
* Test Headroom against LiteLLM.  
* Test LangChain against the configured gateway.  
* Test the full user-facing chain.

This avoids guessing which component is failing.

## **Documentation Requirement** {#documentation-requirement}

Every service-chain mode should be documented.

Documentation should include:

* Active request path.  
* Required services.  
* Required ports.  
* Required environment variables.  
* How to validate the chain.  
* How to bypass each optional layer.  
* Common failure points.  
* How to revert to the previous chain.

This is especially important because the project will be built in phases and may be used by a coding agent during implementation.

## **Summary** {#summary-4}

The aMMare service chain must be able to evolve without forcing major rewrites.

The core strategy is to use logical endpoints, external configuration, deployment profiles, and validation scripts. Early phases may connect LangChain directly to a local model, but the implementation should preserve the ability to insert LiteLLM, cloud providers, Headroom, memory, retrieval, and OpenHands later.

Each rewiring event should be deliberate, documented, and validated before additional complexity is added.

# **One-Click Deployment and Modular Install Strategy** {#one-click-deployment-and-modular-install-strategy}

The aMMare platform should support a one-click deployment model while preserving modular component control.

The top-level deployment process should make the system easy to install, but it should not hide all logic inside a single large script. The preferred model is a top-level orchestration script that calls component-specific deployment scripts in the correct order.

This keeps deployment simple for the user while keeping the implementation maintainable for future changes.

## **Deployment Principle** {#deployment-principle}

The deployment process should be:

* Modular.  
* Idempotent.  
* Profile-driven.  
* Configurable.  
* Validated after each major step.  
* Safe to rerun.  
* Easy to troubleshoot.

The top-level deployment script should coordinate the process. Component scripts should own the details of deploying each service.

## **Top-Level Deployment Script** {#top-level-deployment-script}

The main deployment entry point should be:

| scripts/deploy.sh |
| :---- |

This script should:

* Load global configuration.  
* Detect the selected deployment profile.  
* Run preflight checks.  
* Prompt to install pre-requisites (if not found)  
* Determine which components are enabled.  
* Deploy components in the correct order.  
* Call validation scripts after deployment.  
* Print a clear deployment summary.  
* Stop with a useful error if a required step fails.  
* Log deployment operations to a rotating log file

The top-level script should not contain all component-specific logic directly.

## **Component Deployment Scripts** {#component-deployment-scripts}

Each major service should have its own deployment script. 

**Recommended examples:**

| scripts/deploy-local-llm.shscripts/deploy-litellm.shscripts/deploy-headroom.shscripts/deploy-langchain.shscripts/deploy-openhands.shscripts/deploy-memory.sh |
| :---- |

Each component script should be responsible for:

* Loading its component configuration.  
* Checking required variables.  
* Creating required directories.  
* Creating or updating service definitions.  
* Starting or restarting the service.  
* Running a component-level validation check.  
* Reporting success or failure clearly.

This allows components to be deployed independently during development and troubleshooting.

## **Deployment Profiles** {#deployment-profiles-2}

Deployment profiles should define which components are deployed and how they are connected.

**Example profiles:**

| minimal-locallocal-with\-litellmhybrid-local-cloudfull-agenticfull-agentic-with\-memory |
| :---- |

The active profile should be selected through configuration or a deployment flag.

Example:

| AMMARE\_DEPLOY\_PROFILE=minimal-local |
| :---- |

The deployment profile should control:

* Enabled services.  
* Disabled services.  
* Service startup order.  
* Active model gateway target.  
* Optional routing layers.  
* Optional memory and retrieval services.  
* Optional coding-agent workspace services.

A profile should make the active deployment mode clear without requiring users to inspect multiple scripts.

## **Deployment Order** {#deployment-order}

Services should be deployed in dependency order.

A typical full deployment order is:

| Local LLMLiteLLMHeadroomMemory / RetrievalOpenHandsLangChainOptional UI (and/or configuration to use deployed pipeline) |
| :---- |

Minimal deployments may skip most of these services.

The deployment script should not assume every component is enabled. It should read the active profile and deploy only the required components.

## **Preflight Checks** {#preflight-checks}

Before deploying services, the top-level script should run preflight validation.

Preflight checks should confirm:

* Required tools are installed.  
* Required directories exist or can be created.  
* Required environment files exist.  
* Required variables are set.  
* Required ports are available.  
* Required model paths exist.  
* Required GPU devices are visible if needed.  
* Required secrets are present for enabled cloud providers.  
* The selected deployment profile is valid.

Preflight failures should stop deployment before services are modified.

## **Idempotency Requirements** {#idempotency-requirements}

Deployment scripts should be safe to rerun.

Scripts should avoid assuming a clean system. They should check current state before making changes.

Examples:

* Create directories only if missing.  
* Update service files predictably.  
* Restart only the services that need restarting.  
* Do not duplicate environment entries.  
* Do not overwrite local configuration without warning.  
* Do not delete persistent data during normal deployment.  
* Report when no change is required.

This allows users and coding agents to re-run deployment after changes without rebuilding everything manually.

## **Optional Component Flags** {#optional-component-flags}

The deployment system should allow optional components to be enabled or disabled.

Examples:

| AMMARE\_ENABLE\_LITELLM=trueAMMARE\_ENABLE\_HEADROOM=falseAMMARE\_ENABLE\_OPENHANDS=falseAMMARE\_ENABLE\_MEMORY=false |
| :---- |

The deployment script should respect these flags.

If a component is disabled, the deployment should either bypass it cleanly or report a clear configuration conflict if another enabled component depends on it.

## **Validation During Deployment** {#validation-during-deployment}

Deployment should include validation at multiple levels.

Recommended validation stages:

* Preflight validation.  
* Component-level validation after each service is deployed.  
* Service-chain validation after related services are connected.  
* Final deployment validation.

Example scripts:

| scripts/validate-config.shscripts/validate-local-llm.shscripts/validate-litellm.shscripts/validate-headroom.shscripts/validate-langchain.shscripts/validate-service-chain.sh |
| :---- |

The final deployment result should clearly state which components passed, failed, or were skipped.

## **Uninstall and Reset Behavior** {#uninstall-and-reset-behavior}

The project should include controlled uninstall behavior.

**Recommended script:**

| scripts/uninstall.sh |
| :---- |

The uninstall process should distinguish between:

* Removing containers or services.  
* Removing generated service definitions.  
* Removing temporary files.  
* Preserving persistent data.  
* Removing persistent data only when explicitly requested.

Normal uninstall should not delete models, vector databases, workspaces, logs, or user configuration unless the user explicitly requests a destructive reset.

A destructive reset should require a clear flag such as:

| \--purge-data |
| :---- |

## **Generated Files** {#generated-files}

Deployment scripts may generate runtime files, service definitions, or local environment files.

Generated files should be predictable and documented.

The project should define:

* Which files are generated.  
* Which files are user-edited.  
* Which files are safe to delete.  
* Which files should not be committed.  
* Which files are examples only.

The coding agent should avoid creating undocumented generated files.

## **Deployment Summary Output** {#deployment-summary-output}

At the end of deployment, the script should print a clear summary.

The summary should include:

* Selected deployment profile.  
* Enabled components.  
* Skipped components.  
* Service names.  
* Listening ports.  
* Active model gateway URL.  
* Validation result.  
* Log locations.  
* Next suggested command.

Example summary fields:

| Deployment profile: minimal-localEnabled services: ammare-langchain, ammare-local-llmModel gateway: http://10.1.10.17:8000Validation: passedNext command: scripts/validate-service-chain.sh |
| :---- |

The summary should help the user understand what was deployed without reading logs.

## **Coding Agent Expectations** {#coding-agent-expectations}

The coding agent should implement deployment incrementally.

For each deployment phase, the coding agent should:

* Add or update only the scripts required for that phase.  
* Keep top-level orchestration simple.  
* Keep component logic in component scripts.  
* Add validation alongside deployment.  
* Update documentation when deployment behavior changes.  
* Avoid hardcoded paths, ports, and service URLs.  
* Preserve existing working profiles unless explicitly changing them.

The coding agent should not build a full deployment framework before the early components are working.

## **Summary** {#summary-5}

The aMMare deployment strategy should provide a simple top-level deployment experience while preserving modular control underneath.

The user should be able to run one command for a selected deployment profile, but each service should still have its own deploy and validation logic. This approach supports phased development, easier troubleshooting, selective component deployment, and safer long-term maintenance.

# **Helper Scripts and Operational Tooling** {#helper-scripts-and-operational-tooling}

The aMMare platform should include helper scripts that make deployment, validation, troubleshooting, and ongoing management easier.

These scripts are intended for both human users and coding agents. They should provide fast ways to confirm service health, isolate failures, inspect configuration, and manage model endpoints without requiring manual command discovery.

## **Tooling Principles** {#tooling-principles}

Helper scripts should follow these principles:

* Be simple to run.  
* Produce clear pass/fail output.  
* Avoid hiding important errors.  
* Avoid requiring users to remember long commands.  
* Support both individual service checks and full-chain checks.  
* Read configuration from the same files used by deployment.  
* Avoid hardcoded paths, ports, and URLs.  
* Avoid printing secrets.  
* Be safe to run repeatedly.

The scripts should support daily operation, not only first-time deployment.

## **Recommended Script Categories** {#recommended-script-categories}

The project should include helper scripts in the following categories:

| Category | Purpose |
| :---- | :---- |
| Configuration checks | Validate environment files, config files, ports, paths, and enabled services. |
| Component health checks | Confirm each individual service is running and reachable. |
| Service-chain validation | Confirm requests can move through the active chain. |
| Model management | List, add, remove, and validate local or cloud model endpoints. |
| Log inspection | Show relevant logs for one service or the active chain. |
| Troubleshooting bundles | Collect useful diagnostic output for review. |
| Lifecycle management | Start, stop, restart, deploy, and uninstall services safely. |

## **Core Validation Scripts** {#core-validation-scripts}

The following scripts should exist early in the project:

| scripts/validate-config.shscripts/validate-local-llm.shscripts/validate-langchain.shscripts/validate-service-chain.sh |
| :---- |

As components are added, additional validation scripts should be created:

| scripts/validate-litellm.shscripts/validate-headroom.shscripts/validate-openhands.shscripts/validate-memory.shscripts/validate-model-registry.shscripts/validate-routing.sh |
| :---- |

Each validation script should return a non-zero exit code on failure so it can be used by deployment scripts and CI workflows.

## **Service-Chain Validation** {#service-chain-validation}

The service-chain validation script should test the active deployment profile.

**Recommended script:**

| scripts/validate-service-chain.sh |
| :---- |

This script should:

* Load the active deployment profile.  
* Identify enabled services.  
* Confirm required ports are reachable.  
* Confirm required health endpoints respond.  
* Send a basic test request through the active chain.  
* Report which layer failed if validation does not pass.

The script should not assume the full deployment is always enabled. It should validate the chain that matches the current profile.

## **Endpoint Testing Scripts** {#endpoint-testing-scripts}

Endpoint testing scripts should isolate individual service boundaries.

**Recommended scripts:**

| scripts/test-local-llm.shscripts/test-langchain-gateway.shscripts/test-litellm-local.shscripts/test-litellm-cloud.shscripts/test-headroom.shscripts/test-full-chain.sh |
| :---- |

These scripts should make it easy to determine whether a problem is with the local model, routing layer, Headroom, LangChain, or the full chain.

## **Model Management Scripts** {#model-management-scripts}

The project should provide helper scripts for managing model endpoints.

Recommended scripts:

| scripts/list-models.shscripts/add-model-endpoint.shscripts/remove-model-endpoint.shscripts/test-model-endpoint.sh |
| :---- |

These scripts should work against the model endpoint registry, such as:

| config/models.yaml |
| :---- |

They should help users add new local models, cloud models, or provider endpoints without manually editing multiple files.

When a model is added, the scripts should identify whether routing configuration also needs to be updated.

## **Routing Management Scripts** {#routing-management-scripts}

Routing should be inspectable and testable.

**Recommended scripts:**

| scripts/show-routing.shscripts/test-routing.shscripts/validate-routing.sh |
| :---- |

These scripts should show:

* Active default model.  
* Available model aliases.  
* Enabled escalation paths.  
* Fallback models.  
* Task-to-model mappings.  
* Whether referenced models exist in the model registry.

This helps users and coding agents confirm that routing behavior matches the intended configuration.

## **Log Inspection Scripts** {#log-inspection-scripts}

The project should include scripts for common log checks.

Recommended scripts:

| scripts/logs-langchain.shscripts/logs-local-llm.shscripts/logs-litellm.shscripts/logs-headroom.shscripts/logs-service-chain.sh |
| :---- |

These scripts should collect relevant logs without requiring users to remember container names or runtime commands.

Log scripts should redact secrets and avoid dumping excessive output by default.

## **Support Bundle Script** {#support-bundle-script}

A support bundle script should collect useful diagnostic information.

Recommended script:

| scripts/generate-support-bundle.sh |
| :---- |

The support bundle may include:

* Deployment profile.  
* Enabled services.  
* Service status.  
* Listening ports.  
* Redacted environment summary.  
* Config validation output.  
* Recent service logs.  
* Model registry summary.  
* Routing summary.  
* Service-chain validation result.

The bundle should not include raw secrets, private keys, or full credential files.

## **Service Lifecycle Scripts** {#service-lifecycle-scripts}

The project should provide simple lifecycle scripts.

Recommended scripts:

| scripts/ammare-start.shscripts/ammare-stop.shscripts/ammare-restart.shscripts/ammare-status.sh |
| :---- |

These scripts should operate against the active deployment profile by default.

They may also support targeting a specific service:

| scripts/ammare-restart.sh langchainscripts/ammare-status.sh litellm |
| :---- |

Service lifecycle scripts should use the documented service names and should not require users to know the underlying container runtime commands.

## **Coding Agent Support** {#coding-agent-support}

Helper scripts should make it easier for a coding agent to work safely.

The coding agent should use validation scripts instead of inventing ad hoc test commands whenever possible.

Expected coding-agent workflow:

| scripts/validate-config.shscripts/validate-\<component\>.shscripts/validate-service-chain.sh |
| :---- |

When the coding agent adds or modifies a component, it should also update or create the matching helper script.

If a new service is added without a validation script, the implementation should be considered incomplete.

## **Output Standards** {#output-standards}

Helper scripts should use consistent output formatting.

Recommended statuses:

| PASSFAILWARNSKIPINFO |
| :---- |

Each script should clearly report:

* What was checked.  
* What passed.  
* What failed.  
* What was skipped.  
* What command or file should be reviewed next.

Scripts should return appropriate exit codes:

| 0 \= success1 \= failure2 \= invalid usage or missing configuration |
| :---- |

## **Documentation Requirement** {#documentation-requirement-1}

Each helper script should be documented.

Documentation should include:

* Purpose.  
* Usage examples.  
* Required configuration.  
* Expected output.  
* Common failures.  
* Related scripts.

The main README should list the most important scripts. Component-specific documentation should reference the scripts relevant to that component.

## **Summary** {#summary-6}

Helper scripts are a required part of the aMMare architecture.

They provide repeatable validation, simplify troubleshooting, support modular deployment, and give coding agents a safe way to verify changes. Every major service should have deployment, validation, logging, and troubleshooting support so the system remains manageable as the service chain grows.

# **Documentation Strategy** {#documentation-strategy}

The aMMare project should include documentation for both human users and coding agents.

The documentation should explain the architecture, deployment model, component behavior, configuration files, validation scripts, and safe modification procedures. It should also provide enough implementation guidance for a coding agent to work in phases without losing the overall design intent.

## **Documentation Principles** {#documentation-principles}

Documentation should follow these principles:

* Keep the main README concise and practical.  
* Put detailed component documentation in separate files.  
* Document how to deploy, validate, troubleshoot, and modify each component.  
* Keep architecture decisions separate from step-by-step operations.  
* Update documentation in the same phase as code changes.  
* Avoid duplicating the same explanation across multiple files.  
* Clearly identify optional components and deferred features.  
* Include examples where they reduce ambiguity.  
* Treat documentation as part of the deliverable, not an afterthought.

## **Recommended Documentation Layout** {#recommended-documentation-layout}

**Recommended structure:**

| README.mddocs/  architecture.md  development-roadmap.md  deployment.md  configuration.md  service-topology.md  service-chaining.md  validation.md  troubleshooting.md  coding-agent-implementation-guide.mddocs/components/  langchain.md  local-llm.md  litellm.md  headroom.md  openhands.md  memory.md  models.md  routing.md |
| :---- |

This structure keeps the main README readable while allowing deeper documentation where needed.

## **Main README** {#main-readme}

The main **README.md** should be the user’s starting point.

It should include:

* Project purpose.  
* High-level architecture summary.  
* Supported deployment profiles.  
* Basic prerequisites.  
* Minimal deployment instructions.  
* Common validation commands.  
* Documentation index.  
* Known limitations.  
* Current implementation status.

The README should not try to contain every technical detail. It should point to the correct detailed document when more information is needed.

However, always assume more documentation is needed, but do not assume that you should link directly from the [README.md](http://readme.md/), Rather assume that you will be documenting topics related to an already documented components and add new and additional supporting documents to the appropriate md file linked from the [README.md](http://readme.md/)

## **Architecture Documentation** {#architecture-documentation}

The architecture document should describe the intended system design.

It should explain:

* Core architecture goals.  
* Service chain.  
* Model routing strategy.  
* Tool execution and safety model.  
* Configuration model.  
* Deployment model.  
* Validation strategy.  
* Deferred features.

This document should remain conceptual and design-focused. Detailed commands should live in deployment, validation, or component documents.

## **Component Documentation** {#component-documentation}

Each major component should have its own documentation file.

Each component document should include:

* Purpose of the component.  
* Role in the service chain.  
* Required configuration files.  
* Required environment variables.  
* Ports and endpoints.  
* Deployment script.  
* Validation script.  
* Log inspection script.  
* Common troubleshooting steps.  
* Safe modification instructions.

Component documentation should be updated whenever the component’s behavior, configuration, ports, or service-chain role changes.

## **Modification Guides** {#modification-guides}

The project should document how to modify each major layer.

Examples:

* How to change LangChain prompts or rules.  
* How to modify LangChain routing logic.  
* How to add or remove LangChain tools.  
* How to change the local LLM model.  
* How to add a model endpoint to LiteLLM.  
* How to add a cloud model provider.  
* How to update routing and escalation rules.  
* How to enable or disable Headroom.  
* How to enable or disable memory.  
* How to validate changes after modification.

These guides are important because the system is expected to evolve after the initial deployment.

## **Deployment Documentation** {#deployment-documentation}

Deployment documentation should explain how to install and operate the platform.

It should include:

* Supported deployment profiles.  
* Required host assumptions.  
* Required tools.  
* Required directories.  
* Environment file setup.  
* One-click deployment command.  
* Component-level deployment commands.  
* Uninstall behavior.  
* Reset or purge behavior.  
* Post-deployment validation.

Deployment documentation should match the actual scripts.

If the deployment process changes, the documentation must be updated in the same phase.

## **Configuration Documentation** {#configuration-documentation}

Configuration documentation should explain which files control which behavior.

It should include:

* Global environment file.  
* Component environment files.  
* Model registry.  
* Routing configuration.  
* Secrets handling.  
* Deployment profiles.  
* Example local-lab configuration.  
* Example cloud-provider configuration.  
* Configuration validation command.

This documentation should make it clear where a user or coding agent should make changes.

## **Validation and Troubleshooting Documentation** {#validation-and-troubleshooting-documentation}

Validation documentation should explain how to prove the system is working.

It should include:

* Configuration validation.  
* Component validation.  
* Endpoint validation.  
* Service-chain validation.  
* Routing validation.  
* Model endpoint validation.  
* Memory/retrieval validation if enabled.  
* Expected pass/fail output.

Troubleshooting documentation should provide failure isolation paths.

**Example flow:**

| Test Local LLMTest LiteLLMTest HeadroomTest LangChainTest full service chain |
| :---- |

Troubleshooting documentation should reference helper scripts instead of requiring users to assemble long manual commands.

## **Coding Agent Documentation** {#coding-agent-documentation}

The coding agent implementation guide should provide explicit development instructions.

It should include:

* Build phases.  
* File layout expectations.  
* Script standards.  
* Configuration rules.  
* Validation requirements.  
* Documentation update requirements.  
* What not to hardcode.  
* How to stop at phase boundaries.  
* How to report completed work.

This document should be written as an operating guide for a coding agent that is modifying the repository incrementally.

## **Documentation Update Requirement** {#documentation-update-requirement}

Documentation must be updated whenever implementation changes affect user behavior, service behavior, or architecture assumptions.

Documentation updates are required when:

* A service is added or removed.  
* A port changes.  
* A configuration file changes.  
* An environment variable is added or renamed.  
* A deployment profile changes.  
* A service-chain path changes.  
* A helper script is added or modified.  
* A validation step changes.  
* A troubleshooting process changes.  
* A deferred feature becomes active.

A code change that modifies behavior but leaves documentation stale should be considered incomplete.

## **Avoiding Redundancy** {#avoiding-redundancy}

The documentation set should avoid repeating the same detailed content in multiple files.

Recommended ownership:

| Content Type | Primary Location |
| :---- | :---- |
| Quick start | README.md |
| Architecture decisions | docs/architecture.md |
| Deployment steps | docs/deployment.md |
| Configuration files | docs/configuration.md |
| Service names and ports | docs/service-topology.md |
| Component behavior | docs/components/\<component\>.md |
| Troubleshooting | docs/troubleshooting.md |
| Coding-agent instructions | docs/coding-agent-implementation-guide.md |

Other documents may reference these sections, but they should not duplicate them in full.

## **Summary** {#summary-7}

The aMMare documentation strategy should support both understanding and implementation.

The README should provide a practical entry point. Detailed documentation should live under **docs/**, with separate files for architecture, deployment, configuration, validation, troubleshooting, and individual components. Documentation should be updated alongside code so the project remains usable by both human operators and coding agents.

# **Coding Agent Implementation Guide** {#coding-agent-implementation-guide}

The aMMare architecture document should also serve as planning input for the coding agent.

The coding agent is expected to build the platform incrementally, validate each phase, and update documentation as implementation changes are made. It should not attempt to build the complete architecture in one large pass.

## **Implementation Principles** {#implementation-principles}

The coding agent should follow these principles:

* Build in phases.  
* Make small, reviewable changes.  
* Validate each change before moving on.  
* Avoid hardcoded paths, ports, service URLs, and model names.  
* Use the documented configuration model.  
* Use the documented service names where possible.  
* Keep deployment scripts modular.  
* Keep helper scripts simple and repeatable.  
* Update documentation with code changes.  
* Stop at phase boundaries unless instructed to continue.  
* Commit changes or prompt end-user to commit.

The coding agent should treat this architecture document as the source of intent, but it should still inspect the current repository state before making changes.

## **Phase-Based Development** {#phase-based-development}

The coding agent should work through the roadmap one phase at a time.

For each phase, it should:

* Review the phase objective.  
* Identify required files.  
* Identify affected services.  
* Identify required configuration.  
* Create or update only the files needed for that phase.  
* Add validation for the new behavior.  
* Run available validation.  
* Update relevant documentation.  
* Summarize what changed.  
* Identify what remains deferred.

A phase is not complete until the related deployment, validation, and documentation are updated.

Any changes that are required to fix broken components should be reviewed in order to ensure that the configuration change does not alter the functionality of any existing component of the POC.

If changes are needed that affect the architecture as a whole, there must be a human-in-the-loop (HITL) review, and documentation should be reviewed to ensure that any such changes are well documented.

## **Required Work Pattern** {#required-work-pattern}

For each implementation task, the coding agent should use this pattern:

| Inspect → Plan → Modify → Validate → Document → Report |
| :---- |

The coding agent should not begin by rewriting large parts of the repository.

It should first inspect the current files and understand what already exists. Then it should propose or follow a limited plan, make the smallest useful changes, run validation, update documentation, and report the result.

## **Repository Awareness** {#repository-awareness}

Before modifying files, the coding agent should inspect the repository structure.

It should identify:

* Existing scripts.  
* Existing configuration files.  
* Existing documentation.  
* Existing container or service definitions.  
* Existing tests.  
* Existing examples.  
* Existing naming conventions.

The coding agent should extend existing patterns when they are reasonable instead of creating parallel structures.

If existing files conflict with this architecture document, the coding agent should flag the conflict before making broad changes.

## **Configuration Rules** {#configuration-rules}

The coding agent should use the documented configuration model.

It should not hardcode:

* Service URLs.  
* Local IP addresses.  
* Ports.  
* Model names.  
* Model paths.  
* API keys.  
* Secrets.  
* Deployment profiles.  
* Runtime directories.

These values should come from environment files, structured config files, or documented defaults.

Local IP addresses are acceptable for the lab deployment, but they must still be assigned through configuration.

## **Service Chain Rules** {#service-chain-rules}

The coding agent should preserve the ability to rewire the service chain.

LangChain should not be permanently tied to one backend model endpoint. It should use a logical gateway value such as:

| AMMARE\_MODEL\_GATEWAY\_URL= |
| :---- |

When LiteLLM, Headroom, or another gateway layer is added, the coding agent should update configuration and validation rather than rewriting LangChain unnecessarily.

Service-chain changes should update:

* Environment files.  
* Deployment profiles.  
* Validation scripts.  
* Topology documentation.  
* Troubleshooting documentation.

## **Script Standards** {#script-standards}

Scripts should be written for repeatable operations.

Deployment, validation, troubleshooting, and lifecycle scripts should:

* Be safe to rerun.  
* Use clear names.  
* Read shared configuration.  
* Print clear status output.  
* Return useful exit codes.  
* Avoid destructive actions by default.  
* Avoid printing secrets.  
* Fail clearly when required configuration is missing.  
* Color code status codes for additional clarity.

Recommended status labels:

| PASSFAILWARNSKIPINFO |
| :---- |

The coding agent should not create one-off scripts without documenting their purpose.

## **Deployment Script Expectations** {#deployment-script-expectations}

The top-level deployment script should orchestrate component scripts.

The coding agent should keep this separation:

| scripts/deploy.sh  calls component deployment scripts |
| :---- |

| scripts/deploy-\<component\>.sh  deploys one component |
| :---- |

The top-level script should not become a large monolithic script containing all component logic.

When a new component is added, the coding agent should add or update:

* Component deployment script.  
* Component validation script.  
* Component environment example.  
* Component documentation.  
* Top-level deployment integration if appropriate.

## **Validation Requirements** {#validation-requirements}

Every meaningful implementation step should include validation.

Validation may include:

* Shell syntax checks.  
* Configuration validation.  
* Service health checks.  
* Endpoint tests.  
* Service-chain tests.  
* Routing tests.  
* Model endpoint tests.  
* Documentation link checks if available.

The coding agent should prefer existing validation scripts over ad hoc commands.

If no validation script exists for a new component, the coding agent should create one.

## **Documentation Requirements** {#documentation-requirements}

The coding agent should update documentation when it changes behavior.

Documentation updates are required when:

* A new service is added.  
* A new port is introduced.  
* A config variable is added or changed.  
* A deployment profile changes.  
* A script is added or changed.  
* A service-chain path changes.  
* A troubleshooting process changes.  
* A model endpoint process changes.  
* A deferred feature becomes active.

Documentation should be updated in the same implementation phase as the code change.

## **Error Handling Expectations** {#error-handling-expectations}

The coding agent should implement clear error handling.

Scripts and services should fail with useful messages when:

* Required configuration is missing.  
* A required file does not exist.  
* A required port is unavailable.  
* A service is not reachable.  
* A model endpoint fails.  
* Credentials are required but missing.  
* A deployment profile is invalid.  
* A validation check fails.

Errors should identify the failing component and the next file or command to inspect.

## **Security Expectations** {#security-expectations}

The coding agent should avoid unsafe defaults.

It should not:

* Commit secrets.  
* Print secrets in logs.  
* Print secrets in commit messages  
* Mount broad host paths without reason.  
* Grant unnecessary container privileges.  
* Expose services publicly by default.  
* Disable security controls without explanation.  
* Delete persistent data during normal deployment.  
* Add destructive commands without explicit flags.

Destructive operations should require explicit user action.

## **Reporting Requirements** {#reporting-requirements}

At the end of a coding-agent task, the report should include:

* Files changed.  
* Services affected.  
* Configuration changed.  
* Validation performed.  
* Validation result.  
* Documentation updated.  
* Known limitations.  
* Next recommended step.

The report should distinguish between completed work and deferred work.

## **Stop Conditions** {#stop-conditions}

The coding agent should stop and report when:

* Required information is missing.  
* A validation step fails and the cause is not clear.  
* A requested change conflicts with the architecture.  
* A change would require broad rewiring beyond the current phase.  
* A destructive action would be required.  
* A secret or credential is needed.  
* A new dependency would significantly change the deployment model.

The coding agent should not hide unresolved failures and continue building additional layers on top of a broken phase.

## **Summary** {#summary-8}

The coding agent should treat aMMare as a phased, configuration-driven, service-chain architecture.

It should build incrementally, validate each layer, preserve rewiring flexibility, keep scripts modular, avoid hardcoding, and update documentation as part of every implementation phase. This approach allows the project to grow from a minimal local deployment into a more complete multi-model routing engine without losing maintainability.

# **Memory, Context, and Retrieval Strategy** {#memory,-context,-and-retrieval-strategy}

The aMMare platform may support memory, context management, and retrieval as optional capabilities.

These capabilities should be introduced only after the core model path is stable. The initial system should first prove that LangChain, the local model endpoint, LiteLLM, cloud model providers, and routing logic work correctly. Memory and retrieval should not be added early if they make troubleshooting the base service chain more difficult.

## **Strategy Principle** {#strategy-principle}

Memory and retrieval should improve response quality without making model behavior unpredictable or difficult to debug.

The system should distinguish between:

* Session context.  
* Retrieved document context.  
* Persistent memory.  
* Runtime task state.  
* Tool execution results.  
* User-provided files or project content.

These should not all be treated as the same type of context.

## **Session Context** {#session-context}

Session context is the short-term conversation or workflow state used during an active interaction.

It may include:

* User request.  
* Recent conversation turns.  
* Current task plan.  
* Tool results.  
* Validation results.  
* Files inspected during the current workflow.  
* Current routing decision.  
* Current safety profile.

Session context should be temporary unless explicitly stored elsewhere.

## **Runtime Task State** {#runtime-task-state}

Runtime task state tracks the current workflow inside the middleware.

It may include:

* Active phase or step.  
* Pending tool requests.  
* Approved actions.  
* Rejected actions.  
* Files modified.  
* Commands executed.  
* Validation status.  
* Errors encountered.  
* Escalation decisions.

This state is operational data. It helps the middleware manage the workflow, but it does not automatically become persistent memory.

## **Retrieved Context** {#retrieved-context}

Retrieved context is information pulled from an indexed source to support a specific request.

Sources may include:

* Project documentation.  
* Architecture files.  
* Repository files.  
* Component documentation.  
* Prior implementation notes.  
* Validation output.  
* Troubleshooting guides.  
* User-provided documents.

Retrieved context should be relevant, limited, and traceable to its source.

The system should avoid injecting large amounts of unrelated context into prompts.

## **Persistent Memory** {#persistent-memory}

Persistent memory is information intentionally saved for future use.

It should be treated carefully because stale or incorrect memory can degrade future model behavior.

Persistent memory may include:

* Long-term project preferences.  
* Stable architecture decisions.  
* Reusable environment assumptions.  
* Confirmed naming conventions.  
* Accepted deployment defaults.  
* Known constraints.  
* Repeated user preferences.

Persistent memory should not automatically store every conversation, log, file, or tool result.

## **Memory Storage Rules** {#memory-storage-rules}

The platform should define what may be stored and what should not be stored.

Memory should not store:

* Raw secrets.  
* API keys.  
* Passwords.  
* Private keys.  
* Sensitive tokens.  
* Temporary errors that are no longer relevant.  
* Large unfiltered logs.  
* Unverified assumptions.  
* Data that belongs only to a single task.  
* Generated content that was rejected or superseded.

Memory should prefer stable, confirmed information.

## **Retrieval Backend** {#retrieval-backend}

If retrieval is enabled, the platform may use a vector database or another indexed retrieval backend.

The retrieval backend should be optional.

Possible stored data may include:

* Documentation chunks.  
* Architecture notes.  
* Component guides.  
* Repository summaries.  
* Troubleshooting notes.  
* Known issue records.  
* Validation history summaries.

The retrieval backend should support rebuild or reindex operations so stale content can be corrected.

## **Embedding Model** {#embedding-model}

Retrieval may require an embedding model.

The embedding model may be local or remote depending on deployment policy.

For local-first deployments, a local embedding model is preferred when practical. This reduces external dependency and keeps project content local.

Embedding configuration should be externalized in the same way as model routing configuration.

**Example configuration areas:**

| config/models.yamlconfig/retrieval.yamlenv/ammare-memory.env |
| :---- |

## **Context Injection Policy** {#context-injection-policy}

Retrieved context should be injected into prompts according to policy.

The policy should define:

* Which sources are eligible for retrieval.  
* How many chunks may be injected.  
* Maximum context size.  
* Source priority.  
* Whether retrieved context must be cited internally.  
* Whether stale content should be excluded.  
* Whether sensitive content must be redacted.  
* Whether retrieval can be disabled per task.

The system should favor smaller, higher-quality context over large context dumps.

## **Source Tracking** {#source-tracking}

Retrieved context should be traceable.

When the model uses retrieved context, the middleware should track:

* Source file.  
* Chunk identifier.  
* Retrieval score if available.  
* Timestamp or index version.  
* Whether the source is user-provided, generated, or system documentation.

This helps debug poor responses and makes retrieval behavior easier to improve.

## **Memory and Routing Interaction** {#memory-and-routing-interaction}

Memory and retrieval may influence model routing, but they should not bypass routing policy.

For example:

* A simple request with strong retrieved context may stay on a local model.  
* A complex request with many retrieved sources may escalate to a stronger model.  
* Sensitive retrieved context may force local-only routing.  
* Large context requirements may require a model with a larger context window.

Routing policy should remain explicit and configurable.

## **Memory and Tool Safety** {#memory-and-tool-safety}

Memory should not bypass the tool execution safety model.

Stored context may help the model understand the environment, but it should not grant permission to execute tools, access files, call APIs, or modify infrastructure.

Tool execution should still follow:

* Approved tool registry.  
* Default deny rules.  
* Human approval gates.  
* File access controls.  
* Secret handling.  
* Audit logging.

Memory improves context. It does not expand authority.

## **Indexing Process** {#indexing-process}

The indexing process should be controlled and repeatable.

**Recommended script examples:**

| scripts/index-docs.shscripts/index-repo.shscripts/rebuild-retrieval-index.shscripts/validate-retrieval.sh |
| :---- |

Indexing scripts should:

* Load retrieval configuration.  
* Identify eligible files.  
* Exclude secrets and ignored paths.  
* Chunk content consistently.  
* Generate embeddings.  
* Store index metadata.  
* Report indexed sources.  
* Report skipped sources.

The coding agent should not silently index everything in the repository without clear rules.

## **Retrieval Validation** {#retrieval-validation}

Retrieval should have its own validation process.

Validation should confirm:

* Retrieval backend is running if enabled.  
* The embedded model is reachable.  
* Documents can be indexed.  
* Queries return relevant results.  
* Disabled retrieval does not break the core service chain.  
* Sensitive files are excluded.  
* Reindexing works.

Retrieval quality should be tested separately from model quality.

## **Reset and Purge Behavior** {#reset-and-purge-behavior}

Memory and retrieval data should be removable.

The platform should provide a safe way to:

* Clear session state.  
* Rebuild retrieval indexes.  
* Remove indexed documents.  
* Purge persistent memory.  
* Reset memory services.

Destructive reset operations should require explicit flags.

Example:

| scripts/reset-memory.sh \--purge |
| :---- |

Normal uninstall should not delete memory or retrieval data unless explicitly requested.

## **Documentation Requirement** {#documentation-requirement-2}

Memory and retrieval behavior should be documented.

Documentation should explain:

* What is stored.  
* What is not stored.  
* Where data is stored.  
* How retrieval is configured.  
* How documents are indexed.  
* How memory is cleared.  
* How retrieval is disabled.  
* How to troubleshoot bad retrieval results.  
* How memory affects routing and prompts.

This is especially important because memory-related behavior can be difficult to understand if it is not documented clearly.

## **Summary** {#summary-9}

Memory, context, and retrieval should be optional, controlled, and introduced only after the core aMMare service chain is stable.

The system should clearly separate session context, runtime task state, retrieved context, and persistent memory. Retrieval should be source-tracked, configurable, and validated independently. Memory should improve continuity without storing secrets, bypassing safety controls, or making model behavior difficult to troubleshoot.

# **Deployment Model** {#deployment-model}

The aMMare platform should be deployed as a containerized, local-first service stack.

The initial target environment is a local lab or development host. The platform should not require public inbound access, external orchestration, or a cloud deployment to function. Cloud model providers may be added later as optional backends, but the core system should remain usable with local services.

## **Deployment Goals** {#deployment-goals}

The deployment model should support:

* Local-first operation.  
* Containerized services.  
* Modular component deployment.  
* Static local IPs or local DNS.  
* Optional cloud model providers.  
* Optional memory and retrieval services.  
* Repeatable deployment through scripts.  
* Independent validation of each service.  
* Simple troubleshooting and rollback.

The deployment should begin small and expand only as each phase is validated.

## **Initial Deployment Target** {#initial-deployment-target}

The initial deployment should assume a single local host running the required containers.

The minimum deployment includes:

| ammare-langchainammare-local-llm |
| :---- |

This creates the first working request path:

| User/API Client → LangChain → Local LLM |
| :---- |

This model is intentionally simple. It validates the core middleware-to-model path before additional routing or gateway components are introduced.

## **Expanded Deployment Target** {#expanded-deployment-target}

Later deployments may add:

| ammare-litellmammare-headroomammare-openhandsammare-vector-dbammare-embedding |
| :---- |

The expanded deployment may support:

| User/API Client → LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

Memory, retrieval, and OpenHands should remain optional and should be enabled only when the core model-routing path is stable.

## **Container Runtime** {#container-runtime}

The platform should run each major component as a separate containerized service.

The deployment may use Podman, Docker , or another compatible container runtime depending on the target host. The selected runtime should be documented in the implementation repository. Docker has been selected for the POC as the target system is Ubuntu.

Each service should define:

* Container name.  
* Image source.  
* Published ports.  
* Environment files.  
* Config mounts.  
* Data mounts.  
* Log behavior.  
* Health check.  
* Restart behavior.

The coding agent should avoid assuming that all services run inside one container.

## **Network Model** {#network-model-1}

The default network model should be local and private.

Supported patterns include:

* Single-host container networking.  
* Static local lab IP addresses.  
* Local DNS names.  
* Container service names.  
* Host-published local ports.  
* Multi-host local lab deployment if needed.

Public inbound exposure should not be required.

If cloud model providers are enabled, the deployment may require outbound internet access from the host or routing layer.

## **IP Address and DNS Strategy** {#ip-address-and-dns-strategy}

The platform may use either local IP addresses or local DNS names.

For the local lab deployment, static IP addresses are acceptable and may be simpler to operate.

However, service targets should still be assigned through configuration variables such as:

| AMMARE\_MODEL\_GATEWAY\_URL= |
| :---- |

This allows the backend path to change without modifying application code.

## **Persistent Data** {#persistent-data}

Persistent data should be stored in predictable project or host paths.

Examples:

| data/models/data/vector-db/data/openhands-workspaces/logs/ |
| :---- |

Persistent data should not be deleted during normal redeployment or uninstall unless the user explicitly requests a destructive purge.

## **Configuration and Secrets** {#configuration-and-secrets}

Deployment-specific values should be stored in environment files and structured config files.

Secrets should be stored separately from committed example files.

The deployment should clearly distinguish between:

* Example environment files.  
* Local environment files.  
* Structured config files.  
* Secret files.  
* Runtime-generated files.

No raw secrets should be committed to the repository. No secrets in commit messages.

## **Deployment Profiles** {#deployment-profiles-3}

The deployment model should support profiles.

Examples:

| minimal-locallocal-with\-litellmhybrid-local-cloudfull-agenticfull-agentic-with\-memory |
| :---- |

Each profile should define which services are enabled and how the service chain is connected.

The default profile should be the simplest working deployment.

## **Host Assumptions** {#host-assumptions}

The initial host should provide:

* Supported Linux operating system.  
* Container runtime.  
* Sufficient CPU and memory.  
* GPU support if required by the local model.  
* Local storage for model files.  
* Local network access between enabled services.  
* Optional outbound internet access for cloud providers.

Exact hardware requirements should be documented after the initial model runtime is selected.

## **Deployment Boundary** {#deployment-boundary}

The initial deployment should not attempt to solve every production concern.

Deferred or optional areas may include:

* Kubernetes deployment.  
* High availability.  
* Multi-node orchestration.  
* Enterprise identity integration.  
* Centralized observability stack.  
* Production ingress design.  
* Multi-user authorization model.

These may be considered later if the project matures beyond the local lab deployment.

## **Summary** {#summary-10}

The aMMare deployment model is local-first, containerized, modular, and profile-driven.

The first deployment should prove the smallest useful service chain. Later profiles can add LiteLLM, cloud providers, Headroom, OpenHands, memory, and retrieval. Static local IPs are acceptable for the lab environment, but service relationships should remain configurable so the deployment can evolve without code rewrites.

# **Validation and Success Criteria** {#validation-and-success-criteria}

The aMMare platform should define clear validation steps and success criteria for each development phase.

A phase should not be considered complete simply because files were created or containers started. Each phase must prove that the intended behavior works, that failures are understandable, and that documentation has been updated.

## **Primary Success Criteria** {#primary-success-criteria}

The primary success criteria for aMMare is to prove that the platform can function as a practical agentic coding assistant endpoint.

The end user should be able to configure an IDE, coding assistant, or agentic CLI tool to use the aMMare gateway as its model or agent endpoint. After connecting to that endpoint, the user should be able to submit prompts and receive clear, human-readable responses.

Beyond basic text generation, the platform should also validate controlled agentic behavior. When authorized by policy and user approval, the system should be able to perform practical development and troubleshooting tasks such as:

* Inspecting project files.  
* Creating new files.  
* Modifying existing files.  
* Generating patches or diffs.  
* Running approved scripts.  
* Running tests or validation commands.  
* Inspecting command output.  
* Reviewing logs.  
* Tailing logs for troubleshooting.  
* Checking service status.  
* Identifying likely failure points.  
* Recommending or applying corrective changes.  
* Summarizing what was changed and what validation was performed.

The platform should not only answer questions about code or infrastructure. It should be able to participate in a controlled development workflow where the model reasons about the task, requests approved tool actions, receives tool results, and continues troubleshooting or implementation based on observed system state.

A successful validation result should prove that aMMare can operate as more than a model proxy. It should behave as a controlled agentic middleware layer capable of supporting real coding, deployment, and troubleshooting workflows while preserving safety controls, auditability, and user approval for sensitive actions.

## **Validation Principles** {#validation-principles}

Validation should follow these principles:

* Validate one layer before adding the next.  
* Test components independently.  
* Test the active service chain end to end.  
* Use repeatable scripts instead of manual commands where possible.  
* Return clear pass/fail output.  
* Preserve logs for troubleshooting.  
* Avoid validating optional components when they are disabled.  
* Confirm documentation matches the implemented behavior.  
* Stop before adding complexity if the current phase does not pass.

The project should treat failed validation as a phase blocker.

## **Phase-Level Success Criteria** {#phase-level-success-criteria}

Each phase should define its own success criteria.

At minimum, a phase is successful when:

* Required files are present.  
* Required configuration is documented.  
* Required services start successfully.  
* Required ports are reachable.  
* Health checks pass.  
* Component validation scripts pass.  
* Active service-chain validation passes.  
* Logs show expected behavior.  
* Errors are handled clearly.  
* Documentation has been updated.  
* No secrets are committed.

If a phase introduces a new component, that component should have deployment, validation, logging, and troubleshooting support.

## **Configuration Validation** {#configuration-validation-1}

Configuration validation should confirm that the active deployment profile is usable before services are deployed.

Validation should check:

* Required environment files exist.  
* Required variables are set.  
* Enabled components have required configuration.  
* Disabled components are not required by the active profile.  
* Ports are valid and available.  
* Paths exist or can be created.  
* Model registry entries are valid.  
* Routing rules reference known models.  
* Secrets are present when cloud providers are enabled.  
* No known secret files are committed.

Recommended script:

| scripts/validate-config.sh |
| :---- |

## **Component Validation** {#component-validation}

Each major component should have a validation script.

Examples:

| scripts/validate-local-llm.shscripts/validate-langchain.shscripts/validate-litellm.shscripts/validate-headroom.shscripts/validate-openhands.shscripts/validate-memory.sh |
| :---- |

Component validation should confirm:

* Container or service is running.  
* Required port is listening.  
* Health endpoint responds if available.  
* Required config files are mounted or readable.  
* Required upstream service is reachable.  
* Logs do not show fatal startup errors.  
* A minimal functional test succeeds where practical.

## **Service-Chain Validation** {#service-chain-validation-1}

The active service chain should be validated end to end.

Recommended script:

| scripts/validate-service-chain.sh |
| :---- |

This script should read the active deployment profile and validate the correct path.

Examples:

**minimal-local:**

| LangChain → Local LLM |
| :---- |

**local-with-litellm:**

| LangChain → LiteLLM → Local LLM |
| :---- |

**hybrid-local-cloud:**

| LangChain → LiteLLM → Local LLM / Cloud LLM |
| :---- |

**full-agentic:**

| LangChain → Headroom → LiteLLM → Local LLM / Cloud LLM |
| :---- |

The validation result should identify which layer failed if the full chain does not pass.

## **Model Routing Validation** {#model-routing-validation}

When routing is enabled, routing behavior should be validated separately from basic service health.

Validation should confirm:

* Default model route works.  
* Local model route works.  
* Cloud model route works if enabled.  
* Disabled providers are not selected.  
* Escalation rules select the expected target.  
* Fallback rules behave as expected.  
* Routing decisions are logged.  
* Routing configuration references valid models.

Recommended scripts:

| scripts/validate-routing.shscripts/show-routing.shscripts/test-routing.sh |
| :---- |

## **Tool Execution Validation** {#tool-execution-validation}

If tool execution is enabled, validation should confirm that tool access is controlled.

Validation should check:

* Approved tools are available.  
* Unapproved tools are denied.  
* File access is scoped correctly.  
* Write actions require approval when configured.  
* Dangerous commands are blocked.  
* Secrets are not returned in tool output.  
* Tool execution is logged.  
* Failed tools return clear errors.

Tool validation should be conservative. It should prove that safety controls work, not only that tools can execute.

## **Memory and Retrieval Validation** {#memory-and-retrieval-validation}

If memory or retrieval is enabled, it should be validated independently.

Validation should confirm:

* Memory service is running if required.  
* Vector database is reachable if enabled.  
* Embedding model is reachable if enabled.  
* Documents can be indexed.  
* Retrieval returns relevant results.  
* Sensitive files are excluded.  
* Retrieval can be disabled without breaking the core service chain.  
* Memory or index data can be reset when explicitly requested.

Recommended scripts:

| scripts/validate-memory.shscripts/validate-retrieval.shscripts/rebuild-retrieval-index.sh |
| :---- |

## **Deployment Validation** {#deployment-validation}

A successful deployment should produce a clear summary.

The summary should include:

* Active deployment profile.  
* Enabled services.  
* Skipped services.  
* Active model gateway URL.  
* Published ports.  
* Validation results.  
* Log locations.  
* Next recommended command.

A deployment should not be considered successful if the script completes but the active service chain fails validation.

## **Documentation Validation** {#documentation-validation}

Documentation should be checked as part of phase completion.

Documentation should accurately describe:

* Current service names.  
* Current ports.  
* Current environment variables.  
* Current deployment profiles.  
* Current service-chain paths.  
* Current validation scripts.  
* Current troubleshooting process.  
* Current limitations.

If implementation and documentation disagree, the phase should be considered incomplete.

## **Final System Success Criteria** {#final-system-success-criteria}

The final system should be considered successful when:

* The selected deployment profile deploys cleanly.  
* All enabled services start successfully.  
* All required health checks pass.  
* The active service chain passes end-to-end validation.  
* Local model routing works.  
* Cloud model routing works if enabled.  
* Escalation and fallback behavior match policy.  
* Optional components can be disabled cleanly.  
* Logs are useful for troubleshooting.  
* Helper scripts work as documented.  
* Documentation is complete enough for a new user or coding agent to continue safely.  
* No secrets are committed.  
* Destructive actions require explicit user intent.

## **Failure Criteria** {#failure-criteria}

A phase should not proceed if:

* Required services do not start.  
* Health checks fail.  
* The active service chain fails.  
* Configuration is unclear or duplicated.  
* Required scripts are missing.  
* Logs do not identify the failure point.  
* Documentation is stale.  
* Secrets are exposed.  
* The implementation requires manual undocumented steps.

Failures should be fixed or documented before moving to the next phase.

## **Summary** {#summary-11}

Validation is a required part of the aMMare development model.

Each phase should produce a working, documented, and testable system state. Component validation proves individual services work. Service-chain validation proves the active request path works. Final success requires the deployment, routing, helper scripts, documentation, and safety controls to behave consistently with the architecture.

# **Deferred v2 Features** {#deferred-v2-features}

The initial aMMare implementation should focus on proving the core local-first, multi-model routing architecture.

Some features are valuable but should be deferred until the base platform is stable, documented, and validated. Deferring these items keeps the first implementation achievable and reduces troubleshooting complexity.

## **Deferral Principle** {#deferral-principle}

A feature should be deferred when it adds complexity without being required to prove the core architecture.

Deferred features may be revisited after the platform can reliably:

* Deploy the minimal local service chain.  
* Route through LiteLLM.  
* Add at least one cloud model provider.  
* Apply routing and escalation rules.  
* Validate the active service chain.  
* Use modular deployment scripts.  
* Provide clear documentation and troubleshooting guidance.

## **Deferred Features List** {#deferred-features-list}

The following features should be considered v2 or later unless explicitly pulled into the initial scope.

| Feature | Reason for Deferral |
| :---- | :---- |
| Kubernetes deployment | Adds orchestration complexity before the local container model is proven. |
| High availability | Not required for the initial local lab deployment. |
| Multi-node production deployment | Requires additional networking, service discovery, storage, and security planning. |
| Enterprise identity integration | Valuable later, but not required for the first working system. |
| Multi-user authorization model | The initial platform can assume a single trusted operator. |
| Web UI | Useful, but API/script-driven operation should be validated first. |
| Full observability stack | Metrics and logging are useful, but a dedicated observability deployment can come later. |
| Advanced memory automation | Memory should remain optional until the core routing path is stable. |
| Advanced agent collaboration | Multi-agent coordination should wait until single-agent workflows are reliable. |
| Automated production actions | The initial system should not directly modify production infrastructure. |
| Complex policy engine | Basic configuration-driven policy should be proven first. |
| Distributed task queue | Not needed until workflows become long-running or concurrent. |
| Advanced RBAC | Requires a clearer multi-user operating model. |
| External plugin marketplace | Too broad for the initial architecture. |
| Automated self-update mechanism | Should wait until deployment and rollback behavior are mature. |

## **Not Deferred** {#not-deferred}

The following capabilities are not deferred because they are required for the initial architecture:

* Local LLM endpoint.  
* LangChain middleware.  
* Logical model gateway configuration.  
* LiteLLM routing layer.  
* At least one local model route.  
* At least one optional cloud model route.  
* Basic routing and escalation configuration.  
* Modular deployment scripts.  
* Component validation scripts.  
* Service-chain validation script.  
* Component documentation.  
* Configuration documentation.  
* Troubleshooting documentation.  
* Secret exclusion from committed files.

These are part of the minimum architecture required to prove aMMare.

## **Conditional Features** {#conditional-features}

Some features may be optional in the initial implementation but should be planned for structurally.

**Examples:**

* Headroom.  
* OpenHands.  
* Memory and retrieval.  
* Vector database.  
* Embedding model.  
* Cloud model providers beyond the first.  
* Optional UI.

These features should not block the minimal local deployment, but the architecture should avoid choices that make them difficult to add later.

## **Re-Evaluation Criteria** {#re-evaluation-criteria}

Deferred features may be reconsidered when:

* The core service chain is stable.  
* Deployment scripts are repeatable.  
* Validation scripts are reliable.  
* Documentation matches implementation.  
* Routing and escalation behavior is working.  
* Troubleshooting paths are clear.  
* The added feature solves a real operational need.  
* The added feature can be tested independently.

A deferred feature should not be added only because it is interesting. It should have a clear purpose and a validation plan.

## **Summary** {#summary-12}

Deferred v2 features are intentionally excluded from the first implementation so the project can focus on a reliable, local-first multi-model routing engine.

The initial release should prove the core chain, configuration model, routing behavior, modular deployment, validation scripts, and documentation. More advanced platform features can be added after the foundation is stable.

# **Client Tool Integration Strategy** {#client-tool-integration-strategy}

The aMMare platform should be easy to use from common IDEs, editors, and agentic coding tools.

A primary goal of the project is to reduce the barrier to entry for end users who want to route their coding assistant workflows through the aMMare gateway. Users should not need to manually discover endpoint formats, configuration paths, model names, or API compatibility settings for each tool.

The platform should provide both documentation and helper scripts for configuring supported tools.

## **Integration Goal** {#integration-goal}

The end user should be able to configure a supported client tool to use aMMare as its model gateway or API endpoint.

Supported tools may include:

* Zed.  
* Continue plugin for VS Code.  
* Native VSCode chat or compatible model-provider configuration.  
* Cline.  
* OpenHands.  
* Aider.  
* Other OpenAI-compatible clients (GUI/CLI) that allow bring-your-own (BYO) Endpoints

The exact level of support may vary by tool, but the project should aim to provide a clear path for each supported integration.

## **Gateway Compatibility** {#gateway-compatibility}

Where practical, the aMMare gateway should expose an OpenAI-compatible API surface.

This improves compatibility with existing tools that already support OpenAI-compatible endpoints, custom base URLs, or local model providers.

The documentation should clearly define:

* Gateway base URL.  
* Required API path.  
* Model name or alias to use.  
* Authentication requirements, if any.  
* Supported request formats.  
* Known limitations by tool.  
* Whether streaming is supported.  
* Whether tool/function calling is supported.  
* Whether file operations are handled by the client, aMMare middleware, or both.

The goal is not to make every client behave identically. The goal is to make the expected behavior clear and easy to configure.

## **Client Configuration Scripts** {#client-configuration-scripts}

The project should include helper scripts that configure supported tools to use aMMare where possible.

**Recommended script layout:**

| scripts/integrations/  configure-zed.sh  configure-continue\-vscode.sh  configure-vscode-chat.sh  configure-cline.sh  configure-openhands.sh  configure-aider.sh |
| :---- |

These scripts should:

* Read the active aMMare gateway endpoint from configuration.  
* Detect whether the target tool is installed where practical.  
* Locate the expected user configuration path.  
* Back up existing client configuration before modifying it.  
* Add or update the aMMare provider entry.  
* Avoid overwriting unrelated user settings.  
* Print the final endpoint and model alias being configured.  
* Clearly report any manual steps still required.

If a tool’s configuration format changes or cannot be safely modified, the script should stop and provide manual instructions instead of making unsafe assumptions.

## **Manual Configuration Documentation** {#manual-configuration-documentation}

Each supported client tool should have a short integration document.

**Recommended layout:**

| docs/integrations/  zed.md  continue\-vscode.md  vscode-chat.md  cline.md  openhands.md  aider.md |
| :---- |

Each document should include:

* What the tool is used for in the aMMare workflow.  
* Whether the integration is fully supported, partially supported, or experimental.  
* Required aMMare deployment profile.  
* Required gateway URL.  
* Required model alias.  
* Required authentication setting.  
* Manual configuration steps.  
* Validation prompt.  
* Troubleshooting notes.  
* Link to the upstream tool documentation.

The project may link to external installation and product documentation instead of recreating full upstream documentation. The aMMare documentation should focus on what is specific to connecting that tool to the aMMare gateway.

## **Example Configuration Values** {#example-configuration-values}

The documentation should provide consistent example values.

**Example local gateway:**

| AMMARE\_GATEWAY\_URL=http://10.1.10.17:8080 |
| :---- |

**Example OpenAI-compatible base URL:**

| http://10.1.10.17:8080/v1 |
| :---- |

**Example model alias:**

| ammare-default |
| :---- |

**Example local-only model alias:**

| ammare-local |
| :---- |

Example high-reasoning model alias:

| ammare-high-reasoning |
| :---- |

The actual values should be defined in the active configuration files and deployment profile. Examples should not become hardcoded assumptions.

## **Integration Profiles** {#integration-profiles}

The project may define integration profiles for common client use cases.

Examples:

| Profile | Intended Use |
| :---- | :---- |
| basic-chat | Simple prompt and response through the aMMare gateway. |
| coding-assistant | IDE-based code explanation, editing, and review. |
| agentic-coding | Tool-assisted coding workflows with file inspection and command execution. |
| local-only | Uses only local model backends. |
| hybrid-routing | Allows routing between local and cloud model backends. |

These profiles should map to documented model aliases and gateway behavior.

## **Tool-Specific Notes** {#tool-specific-notes}

Different client tools may interact with aMMare differently.

For example:

* Some tools may only need an OpenAI-compatible base URL and model name.  
* Some tools may manage file edits locally and only use aMMare for model responses.  
* Some tools may support agentic workflows but require separate permission settings.  
* Some tools may support custom providers but not full tool calling.  
* Some tools may require manual configuration because their settings are not safely scriptable.

The integration documentation should identify these differences clearly.

## **Validation for Client Integrations** {#validation-for-client-integrations}

Each client integration should include a validation process.

Validation should confirm:

* The client can connect to the aMMare gateway.  
* The configured model alias is accepted.  
* A basic prompt returns a readable response.  
* Streaming works if supported.  
* Coding prompts work as expected.  
* Agentic tool behavior works where supported.  
* Errors are clear when the gateway is unavailable.  
* The client is using aMMare and not silently falling back to another provider.

**Recommended validation prompt:**

Confirm that you are responding through the aMMare gateway. Then summarize the active model route if that information is available.

For coding tools, validation may also include a simple repository-local task such as inspecting a README, explaining a script, or generating a small non-destructive file.

## **Safety and Permissions** {#safety-and-permissions}

Client integration should not bypass the aMMare safety model.

Even if a client tool supports autonomous file edits or command execution, aMMare should still enforce its own tool execution policy, approval gates, logging, and scope restrictions.

The documentation should explain where permissions are controlled:

* In the client tool.  
* In the aMMare gateway.  
* In the LangChain middleware.  
* In the local workspace.  
* In the operating system or container runtime.

Users should understand whether a task is being executed by the client directly or by aMMare-controlled tooling.

## **Documentation Requirement** {#documentation-requirement-3}

The main README should include a short “Supported Client Tools” section.

That section should link to the detailed integration documents and identify the fastest path for a new user.

**Example**:

| For the lowest-friction setup, deploy the minimal or hybrid profile, then run the matching integration script for your preferred coding tool. |
| :---- |

The README should not contain every configuration detail. It should point users to the correct integration document.

## **Summary** {#summary-13}

The aMMare client integration strategy is intended to make the platform easy to adopt from existing coding tools.

The project should provide scripts and documentation for tools such as Zed, Continue for VS Code, native VS Code chat, Cline, OpenHands, and Aider. The goal is to let users quickly configure their preferred IDE or agentic CLI to use aMMare as the gateway endpoint while preserving clear documentation, validation steps, and safety boundaries.

[image1]: <data:image/png;base64,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AQcUwmoiO+6446b33ntvEW/b/P3333V5LbjggmH5lVdeKdLY/madddaQhrQsU66//vqrSBcTi+wtt9wS1vfo0SN98skn0/HGGy/E+7L89ttvwZ9kkknSCy+8sNheNI9ElBtfYaI5eJHt0qVL+vbbbweBg8022yz97rvvgkAhsnPPPXeRPhbZG2+8MYQfeeSRoidL+tNPPz1ddNFF0+222y6IrBFX8ddff10nirD11lun0047bfrss8+G/V9wwQVF+lhkEXITc8BHRDt27Jiee+65YdurrroqiK8uq/alaMyinPgKE82BU/3+++8HcaW3t/766xfxMNdccwV/8803D6J58MEHF9vGImvb3HTTTYXI9u3bN11rrbXSnXbaKX366acbimxL/phjjhkEHeFHRD/44IPahmm9yPrtEFgL2+sI/Kuvvloi287UWrIoLb7CRHN46aWXgvjEp5zwIYccEsILLbRQWH7hhRdaLbIWhummmy4IJjQSWXq600wzTbE8yyyzhPAbb7wRlscYY4zBxNHKi1tzzTUHK//kk08+WFoLi/YjEeXGV5gQrYFLx151iJGLb9OiZPgKE0JUC9+mRcnwFSaEqBa+TYuS4StMCFEtfJsWJcNXmCg/2Kn+/PPPwbrg008/DaZZP/30U7BeIP6bb74p0tp703HGGSesG3vssYt1MWb3KqqHb9OiZPgKE+Wne/fuwY9FFrAu8CJ77bXXpj/88EORpiXefPNNHyUqgm/TomT4ChPlx6rNi+xYY40VRPbjjz9Of/311yItcd9++22xvRi18G1alAxfYaL8nHXWWeHDARNZqtEe9xFUlq1qb7/99uAfccQRIY4vxSBOAxNOOGERFtUibs+ihPgKE9Vgl1128VGD8csvv/ioFunTp4+PEhXBt2lRMnyFCSGqhW/TomT4ChNCVAvfpkXJ8BUmhBjEn3/+GVyZ8W1alAxfYSMT7D9h4YUXDj6Tmpg50vHHHx8GdeDhhx8uLnw7hM8//zwMAsEXX3yRnnfeeUVaOPbYY0Pa++67L/3jjz9CHMTztnqYQxUYZDKOPPLI4JMfnH322enJJ5+cnnnmmcEmtUOHDumJJ54Y1lkZLO0pp5wSfMr3ySefFDNeMVUg2LHec889xTZHH3108I3vv/8+HOtJJ51UF3/zzTcHK4MTTjihiGOwy471qKOOCn7nzp2L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ChsV4TBjkWX5oYceKnxE9r333gvLXmRXWWWVFkUBkT3++OPTDz74IKxDZCeddNK0V69e6e23356ee+65xXaI7M4775xusMEG6SGHHFInsnF53n333WI/K6ywQt2+6eHiEFmE5oorrkgvv/zyoYrsNttsk+62227piSeeWJdfLLLkM/vss9cdY6PjjssBBx10UDrZZJOlF154YVh33HHHhfjzzjsvLC+wwALBN5EdZ5xxwn4b5WVxMSzbuTHGHnvsIozIWh4DBgwI6SaYYILB8hmVSUS58RU2KsJh0rDpMdryqaeemm6yySbpuOOOW4jslltuGdaZyO69997pd999VzRY/M8//zw9++yz09FHH71hT9byxsXbmcjashdZKw/5jjXWWOkaa6wRyhvnwTIOkZ155pmL+KGJbEu+iexrr70W/K+//rrYz/3331/3qsL2HYcNy3P33Xevy5/zZ+ch7skiypamUV5x3OSTTx7yoHdMjxmWW265Ij0ia+n9+frrr7+KdKMyiSg3vsJGRThMc8cee2zREHk/SthE1tIisrDiiisWaY0xxhgjXXTRRUO4JZE1CNPQ8VsS2QceeCDkGW8DiCxhG2iLj8HeycL444/fKpFFvONlfBNZHq15JLd4K68R7zt28XrwN6R4fUuvCxrlZe6CCy4o4mHOOecMvhfZRuXabLPN6vIdlUlEufEVJoSoFr5Ni5LhK0wIUS18mxYlw1eYaD68c2WAiNNv7umnn27V4y0DeKQbb7zxhmqzy/vm1nLTTTf5qDpY/+WXX/rogl9//bVV5RdtT9yeRQnxFSaaz+GHHx78jz/+OB1ttNFC2ET2lVdeKdLxPveRRx4ploE0iCuWBYRfffXV9J577gnvdgHxZnAOENk333yz2PbRRx9N77333mKZtGzPu0/yYhnHKD1ifuONN4b9AOv79etX5MOIv+WBOZyl8aZyovnE7VmUEF9hov1oJLL0GLE5BZb56KFTp07FNnGVEcZOljwwJWP5qquuKtLgX3PNNcU+lllmmXTrrbdOp5566rAOMcb/6quvgv/ZZ58FHzM0bEP5CIMBMEt//fXXp4sttlgITzHFFOlvv/0WwvH+TJRF+5GIcuMrTDSXTz75pAg3ElnAp3eKT/p4G0tjlhGI7Oqrr163buDAgcGPxRpBtbwsP74wi/cZ+9CnT5/0ySefLIS0f//+wUeU6WXvs88+Yfntt98O6Rn9pzyifaEdixLjK0w0H/tIYUgiaz4Oe1ODsMVj8O9F1hzEIhuv53NiDPp5nRCvi7/agummmy7t0KFDiNt1112Lfcb7wDeRJfz9998X24v2IRHlxleYaD4MfI1qmL2qaH98mxYlw1eYEKJa+DYtSoavMCGazZAsEJhZTAwbvk2LkuErrBl069atMFsizIh5DKPUHuYHiPn555/rlhvBQA3weWlb0tKIOd/6MyIfw6j7iOLNtppJbOJlYE0wJCaccEIfNUzYp8iNePjhh31UmzC0a+LDDz/0UXUMbfuRiW/TomT4CmsGCOvmm28ewrfddlsQWQZ9gBHpyy67LNh5MuptBu+ILBOXwPLLL5/uu+++Icw8A7fcckt4B8igEUJnmMhOP/30we/YsWPxnpDZn4y77rorffnll0OY9Qg4k5YwY5TF2XaIphdZ0jMZiYmszXXANiayzEeABYAdt2GzVDHaz5SHwGQszEcAbIPIYnv6wgsvFBPBME0ik6WAbWdhtkH4bBDNvvFncOvFF18MYcrG/AEWZps55phjiCLLOeIGuMUWW6STTDJJiCO/WGTtPDHPA+lsrgbmQqD81DO9U0vHeeFckzd1iJ3uAQccENYx9wH7Jg/Kd8YZZ4ReL9NA/vDDDyENJmq+t0va+GbH7GWUBxi4Y2IZE0nqjvkrgP1wPFhLILJ2sye/l156qW5OCbZnrgozWwMG/Lp27VqksXibZay9qLVkUVp8hTUDRBYQR0Bk99prr9AQmcfURJbGY3N3IrJTTTVVesopp6R77rlnIbLMeQomrjaCDr4ni9gyeQoiGQslYmQNgakNgYaPmFtaOzVrrrnmYCKLADJ4ZSJLWoQb30SWm4Hfr0G5mAqRtDahCw3e5j9FZLE2uOSSS4rtmVeW8wE2uTdYD5998xWYhc2PRdZ6a7Yee9ghiaxB+rPOOiuE+XChkcjOPffcQYjtmG3CGbuZzjjjjEV6m4UL8zCsFoCpEp999tmwb5uBC7HzrxaIi2+YQJopp5wyiDSceeaZ4cYFc801V/BjkbW6t7IyVWUsskA5n3/++WKZ7e1Yqb8vvvgihM8555wizVJLLVWE25PQkEV58RXWDExkmecTEFl6E8xE1ZLI0tiWWGKJ0KhplI1ElvzmmWeesAyIExd9LLKkP/nkk+vmIOWwrYeIcT7L7IN9/u9//wvCa6cGkaVcTLdnMCUhRvmw3XbbhR4PvTG2Yfasiy++OMyzevTRRwex4Qsqg8dhBPONN94IvXb79HXBBRcMecFCCy0UfG4G1ptqSWTpta688sphPlUTWb7UotzHHHNMiyKLKD722GPh2LCrjc8PPUHOo52nd955Jwiy9aC9yFI2PqvlyWPxxRcPN6uhiSy9R26eJ5xwQvgK7f/+7//CXLom8D169Ahpvcgy5+26664bwtyAAeFl0nUrVyyy00wzTYhvJLKcT+uJUuZYZGPxBLZnpjZEm2sGKB/lNLgmuNa4hu2pqD3Im7IoK77C/mlgUI+YNXPuUfvrgmdknf5G+73uuut8VKtolFd7YOLdDOz1y9Dg2OOb/MiivkWL0uErTAhRLXybFiXDV5gQolr4Ni1Khq+wZsNnmYwQN5qm79Zbbw3vaT/66CO/aoRoNLgDvFv1P+KLYSCFd5JM2vL+++/71e0C56oRd999t48aYYZ0LjzUY1th7+Hj39C0BVgntBXxNcSriv/+97/FGMKwnLdm4Nu0KBm+wpoNI7nAoJbB9+4MSFAcBrS4cPHj+UtbCtMwsVSAlmxpGbmGeBAFqwATMLNUsO25AeDWWWedsC/KZ3+ibfTu1syLoKVyxmY9NjUgtDRHq6WfaaaZin9bgaXHnMhj62wAx5bjfVhZGXgCzgnrGRSLb3xmJsWxx/s37NKJj73RjdPOeUvnhXKYuHJuWRefYwbU/DmK47w5F5x22mnhGiIN62PxtrhGZTUos1kqANvbwBmQPzBASj6U18zjRga+TYuS4Sus2ZjIGvHFbsXBLhKrA1hyySXTXXbZpVjPBe17DmZjCs8880zoZcT5IrI2Em2QDyPQzCwFp59+evHBhIHdJzCabSJr2Og5YC+50korFTaxNGITcBr7p59+GsL8MRawwYRZZ5214e+mOU6Ln3baaYs4Oz/sy4sswgNMRwiIM2AGBoyK2/aUz8zFzMaXc4qwY41g5knQuXPnIhwTlwdR9+cnhv9tARYUENvNgp0fnhbMQmLbbbctRv5bukyxkADWI4x2s7V/gxFvttZmNgbUdaMbss21G88kttpqqwU/FlnA0oD/q5kZ38h60oFaSxalxVdYszGRNZMs/6dS8CJrs1DRozLxjIseiyyP0ZhbxT0cRJZGhZBgogUmsiZ4zJ06LCJrIJSA8CEMgHmWiR3mW9ZTjnt9mExZb9KExYh/mW1iSdg+NkCAvcgaJrZ89EFvzMrBubNzxkcf9sGGmaaZyHLDwKTLMHMpD3mZjTLHgc1roxsG/Oc//wk+x2/HHNefPYrHIstvzO1nky1dpvYDSa4hq2/OVyORtZsVMPeuF1nOj/W67cYLdpOJRdauYa41iawYKr7Cmg2ixNc4Nqfp2muvXdgUmmDxdwDrxbAeMO4320e+fIqFANtUHsH5wstsTXv27Fk0EMyTEFUzTAeWsRMF7CV5BKSHE2PivtNOOxW9HF5z2EcPwGM2YmC9WMpmQkLviXlhAfvPf/3rXyFsH1lgG0pvyP96hqkQyYfGbAbunBvKzDFyozFbzRgeX9kHX1HBvPPOG3zyYl+ICGnsBoc9LuII2DLbIzKvSWxbjt0wW1egPJSDdPaZNPv29qUGH15gvwsIodU1edr7Zd512n5NmOkFN7pMzXRqkUUWKf4mQd3Yq5Knnnoq7MOeOLhZA9fT448/HkQ2fg3B78///e9/h3D86M/NdbbZZguTnxvYH1O3xCHO5NOrV6+wzj7aaE98mxYlw1eYGDm01AssE9ZLbgl+S3P11Vf76BEC0WrLc8NrHPtAY1TBt2lRMnyFCSGqhW/TomT4ChNCVAvfpkXJ8BVWdqzI5jMxyPDAt/7Ad/dVgneyTEYDQ5tWsZHp1YjCKwF7fG+m2RK/yGkJ+xvv0DjqqKOCf9hhh7k1oxa+TYuS4Sus7NigDR8uAB8LMEDF4BODXza4xcQwa621VjGiz2BbbMnAQBoccsghhRXBsssuW0xAAzYwxuAKrL/++sVoNX9+xVwMYptfBoowLWLEfKONNiryYyIXG6Bh2kIGT2xKQgbcGMhhMJBBQCwVYsw0ie1Yz0AWPiLL8cZWC4gTg4ZM8sJkKhCXb8MNNwz+oosumm655ZZBKMnL5gKwQUg7Vwy82QQ/WDQwiGgiyz/ALD0j/WbfyvE3ejdrE8zYYB7n2waqGJiK64d6YYYu8rKyMTUjVgT4l19+edg3g1I2kxfLlM0GxZhch/NvA5ocM2XE9pdpGG2GMyb3ueiii0K4ivg2LUqGr7AqYKP0zGBFozHhQNhoWJgvmYjaKDZpY7Mdm7SFnqzNToVZFc4arY162z+5mPWLkWRmDbO0HrOrJA8b0baeFGZJBgIM5HXQQQeFMCPcHkzOOD4msmE0nypj9iqwnmxcjdi/Wu+eWa08Ldm9WlrLCwuFPfbYozhOs52Ne7Jm/mVzzXLO7cOPuJfLDF5YCfTr1y8sm80q+WLxwD79+eRcMZMYWJnwbQ7aOJ6bqS3bTGVg+znwwAPr7I0xVUO4saIAhLrRuaoKRWMW5cRXWBWw+USt+CayCClCZCJLY6ThIow0ztggnV4hxCKLaQ+9KTP7YYq/hx56qK5xYxtKb4ppFektekhrYmgii7E9NwPExvAiy/pG1WHCEwvq/vvvP1gcsF8M6a1HaDayhpULMA+zDxXs5oPNsK3nWLFXZnJtRIlj3n333YPZl4ms/XWXHj49Uo4P0WQ/1kuP4UZBXVAPmK2xDaZt9CipAzODAi+y9qk15596sXjgHNmPHAmTL2Vj+kJAZHlawZaVfXuR5WbBlIhVpdaSRWnxFVYF7LNUM0CPP1NFHGjoiGxs+hOnAfuogcZpj7mE488pge3s3WZswuSN2Q16smZ7Gj/GI1gxVh7KisgiOkb8nbwJpu3PPlQgjZU1/mSXc2Ii5E2usC22fOIv7+ymQnr7pbedW/ZvZUC8/Oeor7/+evDj48NGtSUQOjufsZ2qffVlUE7brx2fnVegnPFxx8v2Ggd4vWNfCNox26ewlv/QPrMtO75Ni5LhK0wIUS18mxYlw1eYEKJa+DYtSoavMCFEtfBtWpQMX2GiBqZRfGvfaMS/ETZIMzz4d6cQ/5G2LbAfNnqY0wBG5FI48cQT65Y33njjIhz/TTiG96FmDgf8G8uIyxLnJRrj27QoGb7CRA1/ali2n/whWIyoAz/PY3YsRJYRckbFbdCInyYyAMe2jKzbDxBJg60rg0ZsayZQmJ+ZxYCJLIN3TOqCORn5WLnwzfLAZqMCpi7kZ4bMpoV4M70iI+k2em4/qDT69u0bBI/8rHyEsQ7AHIoRf+xkbb82AQ9ltRsQNySbIQxiYbSJZ/gVuplrMcHOkET2yiuvDD5WARLZoWNtWZQUX2FiEPTCMAvDhhJbTLPHNFtQMOFFZJl4JP4hISKLSNqoNqfbzK/wbVtGxhFoLBNsH7HI2hdOVoY777yzbirHWGTZB2nwsWDo0KFDiLee7Oijjx4M8Q3fk2WE3sLMbgaYbVkcImu2x5Y3PdnYosCLrMFfda1sQxJZ5g/GugDhlsgOnag5izLiK0zUQLho7ExFCHyQYJNuxyLLV0T0VhFZvkLi6zP7iqmRyAICynyu2KDS67SeLAJoU/w1ElkM6m2aRfIyseOrNz4cAH6Vs+mmm6bXXntt+uCDD4Yvy7hJ3H777WE95Y3nosWkig8NrGyxyPJF18477xy+0OLX3fyux3qyCKBNfdhIZLFLxZnI8qUeos/XWEzejchSDvvarlOnTkWYT54535hVkRemZy29dhAS2dLjK0yIocHrB24kunzKgW/TomT4ChOiNbT0MYZof3ybFiXDV5gQolr4Ni1Khq8wIUS18G1alAxfYe0Fu2Zgw0bY7b9YEH+T7v9MOyyY/Wn8i+k4zHtFG5m3+DPPPLNYH8fH39bb/8kgzm9Yibf1VREP9MSWBEODx3jOn/3Yz8/FMCyP+Y3sdyGezzX+zXqMTU8Yz09g8yK0RHyc8bwPNpDo5zcw4n1w7DZ3A8T/Y4uJz73NcWEzs4H9m83PeWHYnA1lwLdpUTJ8hbUXtmv7uyiCy4g1jYQwM20x2k5jYCo6m9OVkW77iSCj6tifWn7MC2qwTD78CA9rAPI56aSTwkg6Pn9FtZmvmLOUBs6sTbHIYgNLA6RcNoMV+wTmk2WZPJiNixFxRsGJI6/llluumM8VG1WbKYwfLtrPIcnT5mPFlIpl2w/5YrXALGEIDvOrxmBLirhgYsYELwgfdrOxyMZ/twVG6skfqwRG8ok/9thjQ3mxPohvdEAZbO5X0m6wwQZ152KVVVYJIouFhE3nSDlYz6xZlMXqlfNFGN/gD8HxFIRsw0xgmLJZ3dj5pB6JIy+bNY113AisPEDa2A4YkeXvtPxRlhnPWM9+yYvtmDbSBNdElnjskrEFJj3nALHFSsP+bozIct1w/P68tTe0Y1FifIW1F+za5j1FHLDjxJndpqWxeBNZptNDWIA/m7LuvffeCxd9PJWgP7S4x8U6+zMChvSIue3Hi6ylt/XAjYF0tg9MsEws+JU5DZNGbX9xZbpEzJYAEybLh7hGUwLaFIpM1+ePw7CyAaLKRwyIQiyyiEX8h1mEkONF2M1citm8MM9qhB0zQmbliOsqLlssskBPlj/yWloTdwTOoLwm4jYt5IQTTljMyUud2z5sGkQE3eC8chy2D+u1mxACIsuHHwbbxDB1opXB92RtTmKOJZ4mE7jeOCab+nJkYm1ZlBRfYe2FfS1k4knP0h4x6cXSk+DixZ4Um1ETrBjsM63R0shNOMB/DktPjJ4cwkzjYCZ8eiLWq6SRIlD8zdSw3ic9J4SY2f5ppPSm+AUMpw/7ToNeGr1Lyk3vxv5ogA0rc7ECPVMLIzr0xONHY3rT9Jiwz6WhU1Y+BuAvBh6E1iabRvixgbXpCnml8fzzz9cJIeKDcGD7yvSKYK8V+BuD2cAafGnGMVhPjQ8JOBfUD19wcU65uZAXvUH2b1Me0pMHJjrnmPkCjfAdd9xR5M9Xc/arbcTT6gyRZfLxgdmTQVyP1IH1YuN4brqWD9vdf//9xTr7pTkijv0w7LjjjuGvDMAHFyau8afM6667bjiXdATsJsQ2NkctZeP1hb1uiqdhbG98mxYlw1eYaD1tdfqG9q7yn4D1ZMF6sqJ1+DYtSoavMCFEtfBtWpQMX2FCiGrh27QoGb7CRHOwP98OC/ZLa8Pen5522mnBP++88+LV4h+Kb9OiZPgKKxsMPGArywDQ0GjN4TBTlnH++ecPWtEAy89ELcYmXAGb4GVIMOgDLdldNiLOl99gm4WEmWS1NGlKPMtWSzA5zdDARKsRzLMLNpA0IrSmzjz2K2+DgcM33nijLm5EGZ5yjSzqW7QoHb7CygZFtGIiNIzcDxgwIMQRZmao2NaSEWH/gUA8jR4ia0Ibj9jbNtjsGrZfRrUBO1EDkbX1iCGj25QHUx98E2b7Nbb92RWRjT+wwKoCsN1lhN0M7/nZIOk4ZsDcKTZFAgbMKIM/XmxfY4N8zKqwerCPPBBpLA9iywizUrC/wiLgJrKYu8UfApjIYn0AlAGLC447FmY7P/wkktnJWE8cdqtmHhVfgkyFGMfx593YDtri+SX89ttvH/LjfMUiy3y6lp71mASaBYmBlYiBdQDp4j/1QhwuO4koN77CygYTRxv9+vUrwnHRbfJqi+Nvpf7QmCgbENgHHngghBvZh8aP4JaH/V0VmIIPvMj+73//K9LQaJlmEOKvkQCRtV45vgkVIgvY1/LBhJms9e7dO/jcSBqJLDz66KPFL87h4osvLsQa8yZE2OxmDW4wcU/ZRNbgr78mmLzqYF/WC/c9Wc5Do968nR9+PW52ycB8uDaFZFxPXmTPOuuswhyLOIs//fTT68z1WhJZo0ePHkUY7IYHZiNrrLjiisXNoCqEhizKi6+wshGLLF9Lde7cOYRpuHx9hZhgg0mP0A4H+9H4VQDx1hu1xo1RvtmKst6+jmIOVXqNQAPkKyGDdPZRAUboiE3Hjh0LgWE9trJDE1nSWVkpAzcJRJYJv3v27BnirafHhwkcJ18xNRJZjhVbY+yKDb6Is/zpWSNeiCyvLLAjpYfM6wLKwjmFRiJLHqTliztsY2OwMY5Ftn///uFGYH9gsHigrqg3yort7+qrrx7OETa42PfaXLSNRBZ7WM4xYssy+z3yyCOLdLhGIovdKnXNMdvHFBwHkJ/dmCkDH2dwI1pnnXWKfXO+2Y6yl51ElBtfYaJ9oVenahAjgm/TomQMeOOt9Jfsji0nJ1ct93P2lLFCn9D7FkKMLLr26K1GKIQQzUIiK4QQTUQiK4QQQgghhBBCCCGEEEIIIYQQQoghI+sCIYRoIhJZIYRoIhJZIYRoIhJZIYRoIhJZIYRoIt26917MxwkhhBBi1GY0HyGEqCa/Zu6SzC3gV7SSOXxEGzChj2gnns7cOpkb3a9oBY/4iIgxM9c1d4QbsYFb/tYtCyFGASbI3M6ZWzlz/TP3n8yNl7njM3dWnuauzI2Vucsy93jmtszcCpn7LnP7Z27mzJ2SuZfz9PBZ5n7J3HqZOzZzf2Rum8xNnrlzMvdqnq5X5o7L3Ht5Gpg6c38ntbIYl2du+8ztldTy/FfmJsrcN5mbJkrH+/aj8/CzSS1vBJTwS5YoY/Hcvy33Oye1bUn7Yebuz+MvzNwnSe0cjZ/Ujum0zE2XDDoG42a3bEySuWsyd2LmpsjcVZnbLqmJ7FqZWy2pneMXbAMhRLWxHiyig0iNkdTEpX8e3yOpCQ7x8SPsPEktvfVkOyWDtiXd73k8HJbU8gB8BJt0uyW1tF/k6+jBDkhqIst6xA4QffI2EFkgLwSLtDsmtZuE5QWIP7APRAy/Yx6HwBlL5r6JLJjIxnBzWTEPkzciCyck9T1ZynpL7nv+nfvkf2AUtp4s4s25uy5fFqLayLogmS9z70TLH+X+lbnfJamJTZwG3k4G9bbo7e2Tuffz5dczd3Eeht0z924exn8+qT2ab5W51zJ3Rb7u48x1SAYJ1ru5v0lS24eByJIW0UTIHsvcZvm6sS1RxunJoDINzNzWefjdzO2ah8FuHudHce/m/lvJoF4qj/rL5OGlkprIWrnoSbeWd12Y/dODRfg5LnrjP0dphKgurRXZbj1W7t3atKLpWE/WMyL1MzwDTdaTbQa+Fy1ENWmNcHZZtveepGtN2rKzZM9eq/o4IYRoGsMinPPO2zd+FBVCCDE0hkVkRzF4j8mofWtg1NvDiHoj7F3sn3WxjbnDR7QSHu2pt039ilawR+6z/QPxiggsIIZE/ChPPriWTLM8WGv8lodt26Uz1y2pWWzE8cDgoBCigtgACzC4w6j5opl7JXNbJDXzqvMyd25SE9mNMndBnh5BuTdz12eue1L/bpIRegbT/kpqo/Edk1r+pMESAZOrN5LaYBgii+nXTEnNXvfFpMZPyaCBtgWTmuBMny+DvT+1wTkGoTDjWj0PH5TU8rN18Y3UBpQwvQJuBtNmbuGkZk7GORknc48mNTMyjsEGpIzZojAmZoBZGJYRlAM4xkmT2kDeKskgEe6dpzGhNptgzOGeysMwMPe5GQohKgoNHEsARvv7585EY6HcB0T20qReBDBR+iEPnxzFxz1ZPlnunzu2ZRvsVhFwQGTNdKln5qZMaiZMiNjMeTz4pw1EdsukJo6GpTHfTLQQd+x3DW4OYCKLudQRyaByjpvHY1GAUDcSWcTT2Dtz60fLhpm2eb7M/b65bzcoyk1v1pt9XeuWhRAVAbtSzKhghqTWcwOM5WHGpGYwP29Ss4E9OKnZxhr0/ODNpNbzM7bJfXrB8HlSEyp6yTslNXHpk7nNk5rNqNmoIvikgckyN2sehvOjMLRkCcDNAk5Kaq8zGplV2SsS8pwziuc4yJeywobJoA8wuAGQp4FtrjFxFKb8F+Vhu1k1sne1XjrmcQY9XbObPTWKx8RNCCFKC4/wQgghhBCjIP9g6wIhhGg+ElkhhGgiElkhhGgiElkhhGgiElkhhGgimcjyxZEQQgghhBBCCCGEEEIIIYQQ1aZrz1723ychhBBtjUy4hBCiiUhkhRCiCXTu3nsx+zmihFYIIZqACWyXZfp09euEEEKMIF27935OvVghhGgSffv2HUMiK4QQTUQiK8RIJnuk/DgeIJGTk6uS63WGb9OiZKRCiMry999/60ml7PhKE0JUC9+mRcnwFSaEqBa+TYuS4StMCFEtfJsWJcNXmBCiWvg2LUqGrzAhRLXwbVqUDF9hQohq4du0KBm+woQQ1cK3aVEyfIUJIaqFb9OiZPgKE63nsssu4wIP4bPOOitdeOGFw7I5g/jxxhuvWLb12267bVhefvnli7hHHnnEDMyDm2uuuQbb7vHHHy+WTz755BC+++676/YZl+Onn35K559//mL5mGOOqUsz8cQTh+UJJpgg+M8880yIP+GEE4o88ffcc89a5hnjjjtuEQbLC0YbbbR0xx13LOLj48F98MEHRZhzI0aMRJQbX2Gi9bQksh7i4vg55pgj+KOPPnr63XffBZGFzz//PKRDkGOReuyxx9Ktttoq/e2334o48y084YQT1u0jDk8zzTRBZIH9sY64xRdfPMSNP/746XXXXRfCc845Z1j/559/hmXCr732WhDOmJZE9u233y6WoXPnznXLgMjONNNMg8WL4SMR5cZXmGg9JrLmWurJ2vJNN90Ulk1kEaBll102iOypp56aTj/99OkYY4wR0v71118hzUorrZSuvvrqg+VH7zTeT6N9wjnnnJNuuOGGQWTZxwILLDBYWnqocT59+/Yt1r333nvF/mK8yHJMRxxxRDrJJJOE5Z49e6ZjjTVWsd72iUNkJ5100nT//fevK4cYPhJRbnyFidbTmp6siaY5MJG1ZevJsvzjjz+mM844Y7rYYosVcd9++2162GGHpd98803ddvh33nln6MVefPHFdfv25bCeLPGXXHJJOttss6VTTz11EffJJ5+E/I866qiwfP311xfb+rwgFtk+ffoMdozQUjjuyVq5xPCTiHLjK0y0npZE1hzEp5gwQmbr7d2qiewXX3xRpOdxnvABBxxQbM8jO3G///57WPb78PuKMTGzHjDYq4Gtt946LLe0vc/L4nDbb7993fqZZ565Lk0cNqfXBW1LIsqNrzAhRLXwbVqUDF9hQohq4du0KBm+woQQ1cK3aVEyfIWJ5nDffff5qFGagQMH+ijRJHybFiXDV5hoDl999VWwUT3//PODf8stt/gkBXyQQJrTTz/drypoTdVtscUWRXjttddODzrooGCp0B6MOeaYPko0Cd+mRcnwFSaai5lGIbLvvPNOMKV65ZVX0pdeeik944wzwjpE1sCkq3///ukqq6ySdujQIcS99dZbQWT5YGDAgAHpRhttlD788MPhQwAsFhDXCy+8sBDZf/3rX0V+gBUEJmFAPosuumj69NNPB2Fk+dlnny1MzygX4vzggw+G+AsuuCDt3bt32Pazzz5Ld9lll2BhcPPNN4dj6tq1a7hBnHLKKfEuRROpb9GidPgKE80lFlngq6/DDz88hM3g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QgghhBBCCCGEEEIIMWRkXSCEEE1EIiuEEE2gS49eh3Tr0fssRBbfrxdCCDEC9O3bdwwENnef+vVCCCFGEBPZ7t27j+nXCSGEGEG6Lb/KTHonK4QQTUQiK4QQTaRLj16b+jghxEjgsquuS4UQ1WDp5VfVE0rV8JUohCgvF192lUS2avhKFEKUF4lsBfGVKIQoLxLZCuIrUQhRXiSyFcRXohh+/Olk2btG8W+//XbdNsYll1xSt0z43HPPDeFPP/202P6662qDl7bct2/fsPzTTz+lo48+ejreeOOF5fvvvz+97777QnjiiScutoE///wzhP/+++8i/pdffglh+OOPP0Lc+++/n1566aXFdqeddloIP/LII3XHZK5bt25FHmLEkchWEF+JYvjxpzNejsOPP/54XfyQRHaKKaZIf//99yB+k0022WAiG2+DTzr8J554IvgDBgxITz755CC2lubNN98stunVq1c6+eSTpx06dEgPOeSQEGfpYpFdZpll0rPPPjsdd9xxi/VPP/108H/++ecgsibQtt78fffdt4gXI4ZEtoL4ShTDjz+d8bIP4+acc87gD0lkLS1uoYUWGkxkV1xxxTpBM+fzsrCJb8w444yTLrroonVxpIlFtqU8P/nkkxCOe7JbbLFFXVm+/PLLYhsxYkhkK4ivRDH8+NMZL8fhYenJsmyukcjiGyzffPPNdb1W+P7774swPo/4CKvxzTffBBdDOi+y5oyZZpqpCA+pJyvaDolsBfGVKIYfTqc5W47XxeFGzq8zkeVRftJJJ20osjFxHm+99Va60047FXndcccd6auvvpqecsopdWmhJZE199FHHxXvfXk1cOyxx4awF9l4m7gsRx55ZJFOjBgS2QriK1EIUV4kshXEV6IQorxIZCuIr0QhRHmRyFYQX4lCiPIika0gvhLF8IPB/nHHHRdsT/Efe+wxn6SAQS0P9qtD4vXXX/dRDbnxxht9VEMo49hjjx38RnTt2jX966+/0jvvvDM9//zz/erAmGOOma688srp7rvv7lcVYN8r2gaJbAXxlSiGjxlmmKEIn3rqqcE3kd17773T+eefP4R33XXX4Mciu+SSSxbhCy64IHyp9cADD4Tl9ddfP+3Xr18Qu5dffjnE8YECzDfffMV2Cy+8cBG+8sorgxUATDLJJOkYY4wRwlbdsanVhBNOWLfuhRde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jj/5TL1frhq+EkW5aO9Bm2x/P/kyiPJw8WVXtev1INoAX4miXEhkRYxEtoL4ShTlQiIrYiSyFcRXoigXElkRI5GtIL4SRbmQyIoYiWwF8ZUoyoVEVsRIZCuIr0RRLiSyIkYiW0F8JbaGGWecsW75iiuuCHGPPPJIEderV690wQUXTP/++++w/PPPP4c0b731Vlgm/NRTTxXpLc7y/uuvv+r207t373SJJZYo8mPdLLPMkq611lph+corryy2X2aZZQYrI6y99tpFmkMPPbQujYXx55tvvnS//fYrlnErrbRSkXbjjTdOO3ToUCzH28Zxdszmhoeyiaw/HvzFF188/fTTT8My/txzz50ee+yxxfo99tijCH/55Zd1eZj79ttv65at/nEvvvhibecZvm7jsuy5556h7n755Ze6dWussUZY/u677+r2wfL3339f5GX06dMnnXjiievKHfPBBx+kk08+efq///2vWG/5WFr8eeaZJ91pp52K7QzW2XX8zjvvhOUuXbqkf/75Z7rmmmumxx9/vNtiEBLZCuIrsTXEm913331hmUaC/8Ybb4QLcMopp0zvuOOOIm3Hjh3Tnj17plNMMUWRx8MPP1zkY3GWHhGcYIIJQnisscYKgnr//fcX6/G5sJdbbrnQqM4777z0p59+Co7lRoe29NJLF2l+//33kGa00UYL6yw9AvHNN9+k4447bhF/1llnhcZNmMYx4YQThjzispg/xhhj1MVZOvzhoWwim+THYseDP3DgwLpzgJDiIxb4OEQT//PPPw/bjDfeeEU+xH/99dd1eVv6+DzDHHPMEZZvuOGG9Jlnniny33DDDYP/xRdf1JWF7S+77LIgwNRrvA+WEVrPZJNNlv7www91+cSwzLUXr+f6t7D5dkwxlu8pp5wSlgcMGBDK8uqrr4b4rl27pgceeGDdNjES2QriK7E1xJsRvummm0KYC3+22WYb7MICi4v9RiJrPSDCe+21VxE2EEVrgMZMM80URJaeNK7RxQ2IrKWxxjv++OOHdZZ+3nnnLdI/+uijIZ68OTbCJ554YrGeZRpwfEw+Px8eVsoosj/++GNwxq+//hrixxxzzHSxxRarS4t76KGHijAiC4hsnM7qzOonrmPzAZG95ZZbwnVAPGJleRuTTjppePKJ4wibyJL/Sy+91FBkG/U843y4+Xbu3DmE7VhY30hk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//zzMO3bt282ySSThHnEVvltttlmoXymYbDIFpC0Ek39QADfe++9MK+/6126dAnTbbbZJnviiSdy8YW33norn6dXF/zyyy95ZwZaj7RC4YADDsjzopvq4MGDw/zPP/8cWp6I3jfffBP8aIHur7DCCitku+++e2jZglqiMZdcckmYKv911lknHA9oUcNnn32Wb6crbRyL4LzzzstjJ/ACadeuXZjn1pJPLwJsGgaLbAFJK9HUn5tvvjldNdES31q8MEzDYJEtIGklGmMqF4tsAUkr0RhTuVhkC0haiUWAYpezcJfj0EMPTVdVC65I+vZYF/AMqA+ffvppPq94ro899liUomYIU4hRCk499dSSbR07dixZrg38rX/55ZfT1QECz8TwrZeoXEC5d9hhhzC/9tprR6lqpja3H14ZKbX5/KDr0tKwyBaQtBKLwlVXXRWmzz77bB4QhShQWOVxGfrggw+CS9M+++wTfDnhq6++ymaZZZbshRdeCMu77LJLdvbZZ4d5jDmLLLJIENlHHnkkCACWd4xSsRjCRhttFKYYr0iH4enOO+8MeeBFsPTSS2fvvvtuMEyxnQf+zDPPzPbaa6+wH/lh8Y/zXWihhcL0+++/z2699dZwbPKizNdcc0223nrrBWs/4QMXXXTRkHbJJZfMQw3GIstx+RFmUP6tlIMgMJQd/1e8CB5//PFs2223zT0aSLPllluGfWeaaabsmGOOCeKPq1ivXr3y/GHgwIG5SHJ+t9xyS5iXyHIsPAsmm2yyIMZ8r+ZYiy++eNiOuxr745FAva200kohpONHH32UXXvttdnKK68cphJZ3NfIUxHFTjvttHAOckdjHWVl/3XXXTfr169fWNa5wU477RTK9M477+Tub0XDIltA0kosAogbIqAHLj0NLORaj8jG1vA4PcI3xxxz5NsQALVkTzzxxDztAgsskKcBiSwg4HJpIuar9uF3++23525We+yxRy72TNkei2zr1q3DlBEMEFkR5ymXKly4eJHwUlCeiOxDDz0UfgJRgY8//jg/Z14auF1xTRBu/Hvbtm0btpFmu+22y+f54TqGYCH+gvPi2DPPPHNY5mXwySefhPlYZGNvA1zKVAbqDVjGWwEI7L3MMsuEjgvUAS9JiFuyxL3VfogsxCIrrwrguqUiC3H9FBGLbAFJK7EoIJ6AGOKsDzfccEM2//zz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U9I0tLovvfTSPO2dd945Tnni66KypPmYumORrXDSCjO1p7qWLH/P+QHbaT1qHhZZZJHQckWYQS1ZPiPsuuuueb733HNPvs+3336btW3bNrvkkkvydfH0o48+GkfUYtSSXXnllbOqqqo8zQ033BBaq7DHHntk33zzTfhUMN988+X7pnkBf/c5R1rc8V/+6srAfHxd1JKddNJJ8zSmflhkK5y0wkztoRV51llnhfmnnnoqCNZ7770X1mm9pprnk4C2880Trr/++tDajNPzV36HHXbQroErrrgiO+CAA7LvvvsuLKfHSI8Vg4hfddVVJdvefffd0JLm+LSGq9s/zUvr+D3zzDMl2wcPHlySJp7XD5SuXN6mblhkK5y0wowxxcIiW+GkFWaMKRYW2QonrTBjTLGwyFY4aYUZY4qFRbbCSSvMNC5XXnllmGLE+v777/P1GM3Erbfems8DvrSkVZoXX3wxt9zH+11++eX5/I8//pgdcsghYf71118PLl8gP1YZ1a677rps//33zx599NF8+aGHHsrnZZjCoKnMbeEAADdzSURBVCf++uuvMP3kk0/ydXfddVeY3nHHHdlzzz1X1iPBNA4W2QonrTDTuMQi+8cffwR3KUQO8IkFRBbXKDwCxL777putueaaYX6hhRYKInbmmWeGZVUjQnr11VfnvqgS2c6dO4epUPpXXnmlRAxxy9JyPD/nnHOGKT68+Pz+9ttv2d9//x16puGVIBeuY445Jlt88cXD/HnnnRempvGxyFY4aYWZxiUWWVhggQVC5wJcuC688MKwLm7JDh8+PIinenxpStXhgnXfffdlm2yySfCvJS29s9ZYY43QwpXIwuabbx5cxn799ddsnnnmCSKJyMe3APuxTAsV4dS2TTfdNPvhhx+yZ599NhwfX1v2pYW80047Zeuuu25oyd577725yMoX1zQ+FtkKJ60w0zhcdNFF6aoS1GGhHAiimGOOOaItYwbSqy1xPohkObglyuVZbl1MWn61yk3jY5GtcNIKM5ULHRkam6Y4hmlYLLIVTlphxphiYZGtcNIKM43PL7/8kq5q8eAR0RIgRkSlYZGtcNIKay622WabkqAkDcWNN94YpkTDqo633norXZWTfgMVX375ZbqqQZiQKsG16uuvv05Xj0O3bt3SVeOAF4GIz3XUqFH5fMz555+friqB+Aj1QUF0KoXxfZtuDiyyFU5aYc0FlnUFScFaDvLlfP/993OfUoqssHyAwYVA1ljNsXJjrf/999/z7RLZ448/PkShAgR38sknz9Mgsvh2kofckTbaaKMwjUU2jjaF8OjyEcUKv9QPPvggLK+33np5uvQS6yHdYIMN8nUE7BZKT4Bs5hUWcZVVVgkRsjRPVK54H4xaEtlhw4bl6+Hzzz8vKUcsshtuuGE+DwSfobUWiyx+ukqHyHLNOd7DDz+cG9AQ2ZVWWinMc23lSwsEzwG8KFJ0Hp999llo4VMHsair3HIJUwxc7UdUL/Yh3TnnnDOOAQ4IwQh4aeCBwf3yxRdfhLrYYostStJuueWW2fPPPx+2UY/9+vUL6xWUpxKxyFY4aYU1FzjJ88Ml6IQTTgjrENnHHnss++mnn3KRRTSvueaaMC/Ra9eu3ZhMRkPa+EGLW7I777xzmOeBJp1AZF944YUwL6d9fD4hFlmEj8DUEIssYQTFEkssESJliTTyv0Q2frhjoSPP2WabLZ+XIC699NK5iOtlIRAZXkS1EVmOH4tsnNfaa68dpnQ8iEUWYWMUA0BkyQMDGaEYJaaILHXFvlybESNG5J0j1GmBGLOAn63q6NNPPw1Tyhi/OITKjchOO+20eRBwoJWL2xhQDsp08sknlwg8vPrqq2HkCEBkuVb4J/NyS0V5q622CmVnPYHMjz322HxbBT0uJVhkK5y0wpqD2LVo2223zf1Ead3yGUGtlRTS8gNF9qdFmroP4eNJKxAfUhgwYEB200035dsPPfTQMN1tt93Cw77ddtuFZToE4IcqaIlddtlleVodG9GQsDKKwYMPPpjvozQp+JwSfxbicH+kp0MBIQiZP+mkk8J6Wl78AJHQSwBIr+MQPFu9s2hdr7/++uEFRRnxbwWuK0LENvnrAi+f//u//wvH2XHHHfP1hDO87bbbwjwiTseIPn36hGVGaeBfgs75oIMOCoK42Wab5fsjyux/wQUX5P9O9tlnn+DbC9SxWrl777132CZIr382vDAfeeSRMI9P7wMPPBDm6WyhVv7BBx8cpsTmFbTMeUG2b98+vzZcg1122SVPI3ihnHrqqWEeP2S1nDkGLXdx2mmn5fPNjUW2wkkrrNKJPwVMbKiVbZoGXg5xA6BSschWOGmFGWOKhUW2wkkrrCGYmFtc5Yw7UIQWkSkmFtkKRxW16qqrxvVWFqy34wPLMkYlvplVh8Z3qg6+r2KoGjp0aLqpQeH0Kau+7YkJGXeKPP/3v/+FoWlmmmmmsK5169bhfAi0wl9Qvg8uv/zyyZ71/xQSG/FSoiquFTJwxdQ1j9pQXZ5TTDFF+JasoDmNAd+Ya0saEa0munfvnq7KOe6449JVJUa1CcEiW+GoorAsy7iBS5KszgiELLOILMYgBgLEpQVrMFnMO++8yqakFYtvJAYJ0vTs2TP76quvwkOExR1jFMw444y50ULI8CQoG8YvjDUYSzBqsD8GHUaBxepOiD3KhYEHNy6dGpGj1llnnWDI0RhXQmkoJ1GnyA+XJEQWMXzttdfCdo578803BwOZhsbmPEjHdYiDoVCWdARWQgYKeRcQsAVkXQfy4jwxuGgMLLweEB3qhOvGPC8hDEJyjEdkibyFQUqobJwjLm+c21xzzZXtvvvu2VFHHRU8ATRgo+oCMIbpGpAf5SUNhh9a4wSewZsC8cGLQYY5zgMDHB4cvGQo2yyzzJJH8MKYxbWjTORNnuVa91xXkAfEYYcdFua5R3iBsx+GOQxSc889d4lBlGv18ccfh324L3hp4XGAJwHnDhg2EVk8HXDlIhIZ3gQYMjHacX0pI94VXBeJ7JJLLhnKQPn4cT1xWcPDgXR4lcg7A88R1uOhcPrpp4d1RxxxxJhCjs0LzwxEFgMh5SbUJOcW+wVzHJ4ZwblSH7y8uUeERbbCoZJkGZdVHrcltVpJIquqRHbsbuEhocUW+63qZmZUVYkzNzNiCrRO45asLN4xsgxzkyKa+C2CXJR0fCzJWKMBYVM5aTXgRsQNSR6kp9y498QoH9LIb5aHMm3Jkhdp1K+fh5GXCecFcVxVejYts8wy4djyf5XQcDyJrI7NQy04V1y1QHnLP5OXndyqEDceTK4/goPIkl8c9EX5M9U8Io2Y8BKL3cRi1JLFXYpjI1qkQTgQZs6baynxWWuttcL09ttvD+dGWVR/jH6rFzDCrBcU+VXXyUAiG7+olJYIYCov1n2igMW0adMmTHVP6Xpxj+A5IdSS5WUsLwFeErpHyVfH0XlqmWugecolP2bqWKEo33zzzdzVrEOHDmEat2R1HyCyvAwADwuuK0Kql7a8YVJ4EcZYZCscKklvWSqeBx33prvvvjusO/vss/MWIE7p8mXcc889wxRRiX0XyWOvvfYKbkbAQ62//czz1o/dX2gRkD7lyCOPDMeGa6+9NjvwwAODyOGwLjcdWq/4PUpo9XZnqgeJloQEUj6zQvkwpdy4I8GoUaNyX1NBi003vfbjb79cmcTYSxpivcbdZ+WWJJHFNzf9ds05gs5HsMx1QlRVRtyhaI0haogr5xiPFMsyf7kpK/MqJ9eBvOQfqnMRlE/Xmpau0lDHbMO9iW1q5cfRxRAN+a1yvqoP6peh0uX/TH60Csv9FWcbdZ+CYHM9ub4SLJZZn6YTur78u1Agci3DiSeeGKa0fIH03NdylWOeVq7g2lNurh33MuDyBpQJtzxaytzv3EM0NKB///7jtNpJo2sVh6QE1Ul6DwItePKOnxmLbIUT1V8Of42FhK5SwdG8kkiF0zQs1dyyEzUW2QonrTBjTLGwyFY4aYUZY4qFRbbCSSvMNDypi1hDUJ1RRGAkTL/1pTAMTW2o7jbRd8kJRWOVmfphka1w0gozY8BtCMs/BjSMDRgCMXRh8JF7EAYkLOkYYEgjAwrgZqNlRXIC3LniPvz77bdf1rFjxyCKRCEjChTiSP5Yr2V8QoioLgyTGEY0Oiz+zXK3wzAVG3gIHSnvBfLGSEhsBwxlxDogPwwyuH9xHvJOwFUNA44gHUZPvCgIkKPv4KzH7Q+rOJ4keF3guoU7HHnhtgf4CGME4zgYzThW7GEirwBgvQxTuIThYmVqxiJb4aQVZsZQ7tLgzYAoaRRZBFjuSliecb1R5Kk4yEkssgg1YQ5TkQWEFX9JtUARK1m3EVzKhMgi7ois/DDlh4v7HH7B8neOW7K4RsnlCVc28lJLlnnEmnw4P44RRw/TteC8ccMiHWlYT9hFpUFkgcA3pFG5FMtXAXFIGwtrPC+BxaWKY5jxY5GtcNIKM2PAxQrhwVtAzvNQTmSJYwsIDqHyAJ9O+d7Glxn/T1yrcMOh1VZbkUVAyScWWaDFrCHAaYHiGkSnDIhFlhcAvrH4vuKaxH6xyFIWpWcbw44LtusccJGKR8zVFPc4iWzbtm1Da1vuXRJZIoTRGYKOIfiXqpch/qyKISuRBc5LvrV0oDDlschWOGmFmbrRUN8lzbjgd6uecaZ6LLIVTlphxphiYZGtcNIKM8YUC4tshZNWmDGmWFhkK5y0wowxxcIiW+GkFWaMKRYW2QonrTBjTLGwyFY4aYUZY4qFRbbC2XXPA7KDjzjOP//8K+CvU9ee/6TPtDGmCRn9ENIjyxhjTGNgkTXGmEbEImuMMcYYY4wxxhhjjDHGGGOMMcaYmllttQ2mT9cZY4xpIOzCZYwxjYhF1hhjGhGLrDHGNCIWWWOMaUQsssYYY4wxxhhjjDHGGGOMMcYYY4ypGXsXGGNMI2KRNcaYRsQia4wxjUCHqp79EFj90u3GGGMmEAlsx6qeu6fbjDHGTCAdu/Z4xa1YY4xpJJZbZ51pLbLGGNOIWGSNMcYYY4wxxhhjjDHGGDPR0aFr9w1i53X//POv8n8duq27Yvosmwqk0zrrzJEZYwrHf//9ly1dVTVd+kybCsMia0xxWbmq51zpM20qDIusMcXFIlsALLLGFBeLbAGwyBpTXCyyBcAia0xxscgWgIlBZEefZsnyW2+9FdZpfffu3fP57bbbLltmmWWynXfeOU+jbUxXWmmlML3lllvCb6655grbevfunW244YZ5uviYK664Ynbvvffm65577rlxysRy69atw/zAgQPHOfakk06aXXXVVeGn9H379s2++eabMM/6AQMG5PNxvspjuummC/N//PFHvo7pGmusUbK85ZZbhumCCy4Y1i277LJhqu0qxz///FOyH7/vv/9+nHXxvoMHD87XpeekNDFpXWnKuSyxxBJhuX///iGP33//PV9m2rlz5zirFolFtgBMjCLL8g033JCvR2Q322yz7LHHHstFlm24yKT7ic8++yyI7BxzzBGEboMNNhivyE422WTZ5ptvXlZkhw0bViIkCGEM+7JO6yeffPKQTiIL77333jj5ssy+EiDlHR8LXn311ezXX38t2V/zqcjG5UAotZ7fLrvskoub1t1xxx35sqZ//fXXOOcUpxGI6WWXXZav//LLL7O77767JK/hw4fnebD88ssvZ9dff302yyyz5Pm0VCyyBWBiFVmYdtppwxSRRVxZH4us0mp+kUUWGZPBWBBZhGLJJZfMpp9++iCyrGN+0UUXDcINsciSF6IQl2nPPfcMgh4fU8v8XnzxxTDlOPwAkR0yZEj24Ycf5vtVJ7Ice/HFF89mnHHGsFxOZH/44Yds5MiRJftrPhXZuBzffvttNmrUqHBt5pxzzrCdFxCt3Keeeip7/PHHs6mnnjrfl99iiy1WNi+ti9HyzDPPXLLukUceyedpcSsPHYPf559/nu/TUrHIFoCJRWT79esX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W6fbjDHGNABuxRpjTCNikTWmguhQte5aq3XteaF/Lec3WmSvTNf51/J/nbp075g+36aZWbVrr/Z///NPZoxpGXSo6rFN+pybZqRT115Xp5VkjCkunbr1fCd9zk0zYpE1pmVhka0wLLLGtCwsshWGRdaYloVFtsKwyGbZAw88MM78zz//nJ1++unZ559/nq9P0/F76623socffjhfH2/75ptvSpZff/31sEy+X3zxRb7tkUce0a7Z008/nX300Udh/oUXXsjX69i33HJL9uijj+br+H3yySd5utFVGqbsq+3a97XXXstGjhyZp3388cez++67L8w/+eST+Xrx9ddfh7J+++23Yfmvv/4quQY18d9//2U33XRT2AdUjueee64kj99++62knO+++26Yvv/++3kapY/Tcf3iPJ955pkw//333+f7TaxYZCsMi2yWTTnllNlDDz0U5luNFalJJ500GzZsWDbVVFPl69955518O1NE6JdffsmmmWaaMRmNRduYIjJaRrjbtm0bhEX53HnnndmJJ56YffbZZ9m8886brbvuutn0008fytOtW7dsscUWy/OcffbZg6Afe+yxJcf5/fffS44NP/74Y14Gpssvv3y2xhprZHPNNVd22mmnhTJstNFG2S677BLEd4EFFsjzEFNMMUX26quv5nn27t07W2aZZZJU5WGfAQMGjHO9fvjhhzC/+eabh/WIqbbxO+KII7Jzzjkna926dfbiiy+GNIssski26aabhu3nnXde1qdPn+yPP/4oyXPZZZfNXnnllWzqqacOZZ6YschWGBbZLFtzzTXDA3vvvffmooDwgFqcWo/w/PPPP2F5iy22CC2vciKraZyW/GmJIngffvhhSPP8888H8X3jjTfy/WiNzTzzzEFkWffvv/+G6VZbbZVNMskk2cEHH5znT74//fTTmAOPpk2bNvk8xGWJ1yG4YqGFFiorsohXDPt99dVX2Z9//lmyvhyzzjprmCKCtGpV1meffTbM82O9RJZt559/fhDZ66+/PoisWv6g8tM6Puigg/J17HfrrbcGkeVFRdkWXnjhfL+JEYtshWGRHSOyiGersQ8/sAzzzDNPmGp9OoWaRDaeAq1UraO1icgK1j344IPZUkstlfXv3z+IrNbHZdMLIM4XlHeM0swxxxzZNddck62zzjrZ1ltvnX388cfh2HwOufba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>