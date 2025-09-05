#!/usr/bin/env bash
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
    cat >&2 <<'EOF'
uv is not installed.

Install uv:
- macOS/Linux:           curl -LsSf https://astral.sh/uv/install.sh | sh
- Windows (Git Bash):    curl -LsSf https://astral.sh/uv/install.sh | sh

After installation, re-run this script.
EOF
    exit 1
fi

# Create/refresh local virtual environment and install dev tools
uv sync --group dev

echo "Tooling environment is ready..."
