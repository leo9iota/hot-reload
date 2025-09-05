# Hot Reload Tooling

This project uses GDScript tools from [gdtoolkit](https://pypi.org/project/gdtoolkit/).

## Quick Setup

1. **Install UV**:
```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. **Install Dependencies**:
```sh
just install
```

## Available Commands

### Core Commands
- **`just install`**: Install all dependencies
- **`just format`**: Format all GDScript files (excludes addons)
- **`just lint`**: Lint all GDScript files (excludes addons)
- **`just check`**: Check formatting and run linting
- **`just fix`**: Format code and run linting

### Smart Git-Aware Commands
- **`just format-changed`**: Format only changed files
- **`just lint-changed`**: Lint only changed files  
- **`just pre-commit`**: Perfect for git pre-commit hooks

### Utility Commands
- **`just version`**: Show gdtoolkit versions
- **`just clean`**: Clean Python cache files
- **`just count-gd-files`**: Count GDScript files in project

## Typical Workflow

```sh
# One-time setup
just install

# During development
just format          # Format your code
just lint            # Check for issues
just check           # Comprehensive check

# Before committing
just pre-commit      # Format and lint only changed files
```
