#!/usr/bin/env bash
set -euo pipefail

TARGET=${1:-.}

# Format all GDScript files under the target
uv run gdformat "$TARGET"

echo "Formatted GDScript under: $TARGET"
