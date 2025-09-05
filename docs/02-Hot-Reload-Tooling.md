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

## Commands

- **Setup Project**:

```sh
just setup
```

- **Format Code**:

```sh
just fmt
```

- **Check Formatting**:

```sh
just fmt-check
```

- **Lint Code**:

```sh
just lint
```

- **Check Code**:

```sh
just check
```

