#!/usr/bin/env python3
import sys
import subprocess
import tempfile
import json
import os


def main():
    if len(sys.argv) < 2:
        print("Usage: check_commit_msg_secrets.py <commit_msg_file>")
        sys.exit(1)

    commit_msg_file = sys.argv[1]
    if not os.path.exists(commit_msg_file):
        print(f"Commit message file not found: {commit_msg_file}")
        sys.exit(1)

    # Read commit message and strip out comment lines (starting with '#')
    with open(commit_msg_file, "r", encoding="utf-8") as f:
        lines = f.readlines()

    clean_lines = [line for line in lines if not line.strip().startswith("#")]
    clean_text = "".join(clean_lines).strip()

    if not clean_text:
        # Empty commit message, let Git handle it
        sys.exit(0)

    # Write clean content to a temporary file for detect-secrets to scan
    # Create the temp file in the workspace root so detect-secrets doesn't ignore it
    with tempfile.NamedTemporaryFile(
        mode="w+",
        suffix=".txt",
        prefix=".commit_msg_",
        dir=".",
        delete=False,
        encoding="utf-8",
    ) as tmp:
        tmp.write(clean_text)
        tmp_path = tmp.name

    try:
        # Run detect-secrets on the temp file
        # detect-secrets is installed in the python environment because of additional_dependencies
        result = subprocess.run(
            ["detect-secrets", "scan", tmp_path],
            capture_output=True,
            text=True,
            check=True,
        )

        scan_result = json.loads(result.stdout)
        results = scan_result.get("results", {})
        secrets_found = []
        for file_path, findings in results.items():
            for finding in findings:
                secrets_found.append(finding)

        if secrets_found:
            print("CRITICAL: Potential secrets detected in commit message!")
            for secret in secrets_found:
                print(
                    f" - Type: {secret.get('type')} on line {secret.get('line_number')}"
                )
            print(
                "\nPlease remove the secret from your commit message before committing."
            )
            sys.exit(1)

    except subprocess.CalledProcessError as e:
        print(f"Error running detect-secrets: {e.stderr or e.stdout}")
        sys.exit(1)
    except FileNotFoundError:
        print("Error: detect-secrets executable not found in path.")
        sys.exit(1)
    finally:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)

    sys.exit(0)


if __name__ == "__main__":
    main()
