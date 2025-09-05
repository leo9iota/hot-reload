# Default recipe to display available commands
default:
    @just --list

# Install Python dependencies using uv
install:
    uv sync

# Format all GDScript files using gdformat (excluding addons)
format:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    find . -name "*.gd" -not -path "./addons/*" | xargs -r uv run gdformat

# Format specific file or directory
format-path path:
    uv run gdformat "{{ path }}"

# Check formatting without making changes (dry run)
format-check:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    find . -name "*.gd" -not -path "./addons/*" | xargs -r uv run gdformat --check

# Check formatting for specific path
format-check-path path:
    uv run gdformat --check "{{ path }}"

# Format with specific line length (default is 100)
format-line-length length="100":
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    find . -name "*.gd" -not -path "./addons/*" | xargs -r uv run gdformat --line-length {{ length }}

# Lint GDScript files using gdlint (excluding addons)
lint:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    find . -name "*.gd" -not -path "./addons/*" | xargs -r uv run gdlint

# Lint specific file or directory
lint-path path:
    uv run gdlint "{{ path }}"

# Parse GDScript files to check syntax (excluding addons)
parse:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    find . -name "*.gd" -not -path "./addons/*" | xargs -r uv run gdparse

# Parse specific file
parse-file file:
    uv run gdparse "{{ file }}"

# Format and lint everything (comprehensive check)
check: format-check lint
    @echo "All formatting and linting checks passed!"

# Format everything and run comprehensive checks
fix: format lint
    @echo "Fixed formatting and completed linting!"

# Clean up Python cache and build artifacts
clean:
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find . -name "*.pyc" -delete 2>/dev/null || true
    find . -name "*.pyo" -delete 2>/dev/null || true

# Show gdtoolkit version information
version:
    uv run gdformat --version
    uv run gdlint --version

# Format only changed files (git-aware, excluding addons)
format-changed:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    changed_files=$(git diff --name-only --diff-filter=AM | grep '\.gd$' | grep -v '^addons/' || true)
    if [ -n "$changed_files" ]; then
        echo "Formatting changed GDScript files (excluding addons):"
        echo "$changed_files"
        echo "$changed_files" | xargs uv run gdformat
    else
        echo "No changed GDScript files to format"
    fi

# Check formatting only for changed files (excluding addons)
format-check-changed:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    changed_files=$(git diff --name-only --diff-filter=AM | grep '\.gd$' | grep -v '^addons/' || true)
    if [ -n "$changed_files" ]; then
        echo "Checking formatting for changed GDScript files (excluding addons):"
        echo "$changed_files"
        echo "$changed_files" | xargs uv run gdformat --check
    else
        echo "No changed GDScript files to check"
    fi

# Lint only changed files (excluding addons)
lint-changed:
    #!/usr/bin/env bash
    # export PYTHONWARNINGS="ignore::UserWarning:gdtoolkit.parser.parser"
    changed_files=$(git diff --name-only --diff-filter=AM | grep '\.gd$' | grep -v '^addons/' || true)
    if [ -n "$changed_files" ]; then
        echo "Linting changed GDScript files (excluding addons):"
        echo "$changed_files"
        echo "$changed_files" | xargs uv run gdlint
    else
        echo "No changed GDScript files to lint"
    fi

# Pre-commit hook: format and check changed files
pre-commit: format-changed lint-changed
    @echo "🚀 Pre-commit checks completed!"

# Show help for gdtoolkit commands
help-gdformat:
    uv run gdformat --help

help-gdlint:
    uv run gdlint --help

help-gdparse:
    uv run gdparse --help

# Count GDScript files in the project
count-gd-files:
    @find . -name "*.gd" -not -path "./addons/*" | wc -l | sed 's/^/GDScript files (excluding addons): /'
    @find . -name "*.gd" | wc -l | sed 's/^/Total GDScript files: /'
