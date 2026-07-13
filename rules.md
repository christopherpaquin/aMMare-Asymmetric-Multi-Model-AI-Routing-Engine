# **aMMare Agent Execution Rules**

All AI coding agents (including Antigravity and any downstream subagents) must strictly follow these rules when developing, modifying, or interacting with this repository.

---

## **1. Repository Documentation Hierarchy**

* **Main README:** The main [README.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/README.md) in the repository root is the entry point.
* **Architecture & Implementation Links:** The main `README.md` must contain an `Architecture & Implementation` section. This section must link directly to the relevant markdown files (such as the architecture specs and phase-by-phase implementation guides under `implementation/` or `architecture/`).
* **Operational Documentation:** We must document the operational details ("HOW" to use what has been deployed) inside the implementation docs or a dedicated operational playbook. This includes:
  * How to **start** services (e.g. CLI flags, compose commands).
  * How to **stop** services.
  * How to perform **health-checks** and verify baseline connectivity.

---

## **2. Audit Logging & Implementation History**

* **Work Log (`WORKLOG.md`):** Agents must maintain and append updates to the [WORKLOG.md](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/WORKLOG.md) file in the root directory.
* **Content Requirements for `WORKLOG.md`:**
  * Chronological record of tasks started and completed.
  * Explicit records of implementation design decisions (e.g., ports selected, directories mapped, frameworks utilized).
  * Rationale for choices made to ensure future agents can continue work seamlessly without repeating analysis.

---

## **3. Code Exclusions & Secrets Security**

* **Secrets Exclusion:** Under no circumstances should any API keys, credentials, tokens, or private endpoint URLs be committed to Git.
* **Git Exclusions (`.gitignore`):**
  * All `*.env` files containing system configurations or secrets must be ignored by Git. Only the corresponding `*.env.example` templates can be committed.
  * Keep the [.gitignore](file:///home/cpaquin/Workspace/Git/aMMare-Asymmetric-Multi-Model-AI-Routing-Engine/.gitignore) updated to exclude environment caches, database files, raw models, and logs.
* **Pre-commit Checks:** Always verify that uncommitted files containing credentials are excluded before proposing commits.

---

## **4. Work Pace and Verification Guidelines**

* **Step-by-Step Execution:** Do not skip phases or write large amounts of code in a single run.
* **Verification First:** Each change must be validated using corresponding validation scripts before moving on.
* **Ask Questions:** When requirements are ambiguous, configurations are conflicting, or GPU/host environments behave unexpectedly, stop and ask the user for clarification.
