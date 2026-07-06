# Python Development Rules & Best Practices

All Python development within this project must adhere to the following rules and standards.

## Linting & Formatting

- **Ruff Compliance:** All Python code must be formatted and linted using `ruff` (both linter and formatter). Before submitting any commit, ensure that `pre-commit run --all-files` passes.
- **Line Length:** Avoid exceeding standard line length limits (typically 88 characters, aligned with Ruff/Black defaults).

## Code Style & Type Safety

- **Type Hinting:** Use PEP 484 type hints for all function signatures (both parameters and return values). For complex types, import from the `typing` module or use built-in generic types (Python 3.9+).
- **Docstrings:** Document all modules, classes, and public functions using Google Style docstrings. Explain inputs, outputs, and any raised exceptions.
- **Imports:** Group imports into standard library, third-party libraries, and local application imports. Ruff will auto-sort these; do not bypass it.

## Robustness & Security

- **Error Handling:** Never use bare `except:` statements. Always catch specific exceptions (e.g., `ValueError`, `FileNotFoundError`) to avoid masking unrelated bugs.
- **Path Manipulation:** Always use `pathlib.Path` instead of raw string manipulation or the legacy `os.path` module.
- **Secrets Management:** Never hardcode secrets, API keys, or access tokens in code. Load them from environment variables or secure configuration stores. Refer to `.env.example` for required configuration variables.
