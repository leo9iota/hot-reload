# Hot Reload Tooling

This project uses modern Python tooling via [uv](https://docs.astral.sh/uv/) to install and run GDScript tools from [gdtoolkit](https://pypi.org/project/gdtoolkit/3.3.0/).

## Setup

1. **Install Prerequisites**: Install [uv](https://docs.astral.sh/uv/) with curl.

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. **Setup**: Create a local virtual environment and install dev tools specified in [pyproject.toml](../pyproject.toml).

```sh
bash scripts/setup-tools.sh
```



---


```sh

```

```sh

```

Prerequisites

- Install uv (one-time):
  - macOS/Linux:  curl -LsSf https://astral.sh/uv/install.sh | sh
  - Windows (Git Bash):  curl -LsSf https://astral.sh/uv/install.sh | sh
- Ensure uv --version works in your shell.

Setup

Create a local virtual environment and install dev tools specified in pyproject.toml:

- bash scripts/setup-tools.sh

This creates .venv/ (ignored by Git) and installs gdtoolkit.

Usage

- Format all GDScript files (in-place):
  - bash scripts/format.sh [path]

- Check formatting (no changes, CI-friendly):
  - bash scripts/format-check.sh [path]

- Lint GDScript:
  - bash scripts/lint.sh [path]

Each script accepts an optional path argument (defaults to .), e.g. bash scripts/lint.sh ui/

Configuration

- .editorconfig defines consistent indentation (4 spaces), EOLs, and trailing whitespace rules.
- Tool versions are pinned in pyproject.toml under the dev dependency group.

If you want to customize rules, gdlint and gdformat support configuration files. You can add them later as needed.

Continuous Integration

GitHub Actions workflow: .github/workflows/ci.yml

- Installs uv
- Syncs dev tools (uv sync --group dev)
- Runs formatting check and linting
- Triggers on pushes/PRs that change GDScript, scenes, scripts, or tooling files

Troubleshooting

- Ensure uv is on your PATH: uv --version
- Recreate the environment: rm -rf .venv && uv sync
- Run a tool directly without scripts: uv run gdformat . or uv run gdlint .

