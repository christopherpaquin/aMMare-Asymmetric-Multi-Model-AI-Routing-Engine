# Shell Scripting Rules & Best Practices

All shell and bash scripts within this project must adhere to the following rules and standards.

## Validation & Linting

- **ShellCheck:** All scripts must compile and validate clean under `shellcheck`. A pre-commit hook is in place to verify this. Ensure scripts are properly structured so `shellcheck` can analyze them.

## Safety & Error Handling

- **Set Options:** Always begin scripts with `set -euo pipefail` to ensure scripts fail fast on errors, undefined variables, and pipeline failures:
  - `-e`: Exit immediately if a command exits with a non-zero status.
  - `-u`: Treat unset variables as an error.
  - `-o pipefail`: The return value of a pipeline is the status of the last command to exit with a non-zero status.
- **Double Quoting:** Always double-quote variable expansions (e.g., `"$var"` instead of `$var`) to prevent word splitting and globbing.

## Code Structure & Conventions

- **Shebang:** Always start scripts with `#!/usr/bin/env bash` for maximum portability across Linux/macOS systems.
- **Function Scope:** Declare variables inside functions with the `local` keyword to prevent global namespace pollution.
- **Exit Codes:** Always return descriptive exit codes from functions and scripts. Use `0` for success, and non-zero values for failure.
- **Error Messages:** Direct all error messages and diagnostics to standard error (`>&2`).
