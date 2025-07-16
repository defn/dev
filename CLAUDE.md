# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

- **Build the project**: `b build` or `make build`
- **Build and format all code**: `make all`
- **Regenerate dependencies**: `make regen` (updates Go deps and Bazel BUILD files)
- **Format code**: `trunk fmt`
- **Run linters**: `trunk check`
- **Run specific linter**: `trunk check --filter=<linter-name>`

## Testing

- **Run all tests**: `b test //...`
- **Run specific test**: `b test //path/to:target`
- **Test with coverage**: `b coverage //...`

## Architecture

This is a Bazel-based monorepo for cloud integrated development environments. Key components:

1. **Build System**: Bazel with `b` wrapper command. Main workspace is at `/home/ubuntu/m/`
2. **CI/CD**: Buildkite pipelines defined in `.buildkite/`
3. **Configuration**: CUE for config management, mise for runtime version management
4. **Code Quality**: Trunk.io manages multiple linters (Go, Python, Shell, YAML, etc.)

## Development Workflow

1. Use `mise` for tool versions: `mise install`
2. Format before committing: `trunk fmt`
3. Check code quality: `trunk check`
4. Build with Bazel: `b build //...`
5. Update BUILD files after adding deps: `make regen`

## Infrastructure Commands

- **Start local k3s cluster**: `make up`
- **Stop k3s cluster**: `make down`
- **Generate CDKTF code**: `make cdktf`
- **Update system and tools**: `make sync`

## Key Directories

- `/home/ubuntu/m/`: Main monorepo workspace with Bazel BUILD files
- `.buildkite/`: CI pipeline configurations
- `bin/`: Executable scripts and utilities
- `docs/`: Project documentation