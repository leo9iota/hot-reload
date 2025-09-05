# Use bash so this works in Git Bash on Windows and on *nix
set shell := ["bash", "-euo", "pipefail", "-c"]
# On Windows, force bash (just defaults to PowerShell)
set windows-shell := ["bash", "-lc"]

# Default target path for commands
DEFAULT_TARGET := "."

# Bootstrap uv-managed tooling (gdtoolkit)
setup:
 bash scripts/setup-tools.sh

# Format GDScript files in-place
fmt target=DEFAULT_TARGET:
  bash scripts/format.sh {{target}}

# Check formatting without writing changes
fmt-check target=DEFAULT_TARGET:
  bash scripts/format-check.sh {{target}}

# Lint GDScript files
lint target=DEFAULT_TARGET:
  bash scripts/lint.sh {{target}}

# Run all checks (format check + lint)
check target=DEFAULT_TARGET: fmt-check {{target}} lint {{target}}
  @echo "All checks passed for: {{target}}"

# CI convenience target
ci: check
  @echo "CI tasks completed"
