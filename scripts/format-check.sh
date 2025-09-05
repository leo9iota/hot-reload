#!/usr/bin/env bash
set -euo pipefail

TARGET=${1:-.}

# Verify formatting without writing changes; exits non-zero on differences
uv run gdformat --check "$TARGET"

echo "Formatting check passed for: $TARGET"
