#!/usr/bin/env bash
set -euo pipefail

TARGET=${1:-.}

# Lint all GDScript files
uv run gdlint "$TARGET"

echo "Linting passed for: $TARGET"
