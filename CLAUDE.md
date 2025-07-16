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

## Common Tasks

### Task: mise upgrade

When asked to "run mise upgrade task" or similar, follow these steps:

1. Run `make mise-list` in $HOME directory
2. Check if the output contains only mise commands (ignore any error messages like "Failed to connect to bus")
3. Execute each mise command shown (e.g., `mise use aws@2.27.52`, `mise use --cd ~/m node@24.4.1`)
4. Stage and commit the changed mise.toml files:
   ```bash
   git add .config/mise/config.toml m/mise.toml
   git commit -m "chore: upgrade mise tool versions

   - [list upgraded tools and versions]

   🤖 Generated with [Claude Code](https://claude.ai/code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

This task updates tool versions managed by mise across the repository.