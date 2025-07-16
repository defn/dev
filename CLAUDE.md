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

## Important Directives

- **Always use conventional commits** when committing changes (e.g., `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`)
- **Run `trunk fmt` after making file changes** to ensure proper formatting. This can be run after a series of edits to batch the formatting for efficiency
- **NEVER add secrets to the git repository**. If you encounter any text that looks like a password, token, API key, or other sensitive information:
  - Immediately warn the user about the potential secret
  - Stop any git add/commit operations
  - Wait for the user to decide on further actions
  - Do not proceed with any commits until the user confirms it's safe

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
3. Note the current versions before executing the upgrade commands (check git diff or mise list)
4. Execute each mise command shown (e.g., `mise use aws@2.27.52`, `mise use --cd ~/m node@24.4.1`)
5. Stage and commit the changed mise.toml files:

   ```bash
   git add .config/mise/config.toml m/mise.toml m/w/mise.toml
   git commit -m "chore: upgrade mise tool versions

   - ansible: 11.7.0 → 11.8.0
   - just: 1.42.1 → 1.42.2
   - npm:wrangler: 4.24.3 → 4.24.4

   🤖 Generated with [Claude Code](https://claude.ai/code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

   **Important**: Include the version changes (from → to) in the commit message for each upgraded tool.

This task updates tool versions managed by mise across the repository.

### Task: go upgrade

When asked to "run go upgrade task" or similar, follow these steps:

1. Change directory to m: `cd m`
2. Run `make upgrade` to upgrade Go dependencies
3. Examine changes to `go.mod` and `go.sum` files
4. Summarize **only direct dependencies** changes from go.mod (ignore indirect dependencies marked with `// indirect`)
5. Test if changes compile: run `b build` in the m directory
6. If build succeeds, stage and commit the changes:

   ```bash
   git add go.mod go.sum
   git commit -m "chore: upgrade Go dependencies

   - github.com/example/package: v1.2.3 → v1.2.4
   - github.com/another/lib: v2.0.0 → v2.1.0
   [list only direct dependency changes]

   🤖 Generated with [Claude Code](https://claude.ai/code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

   **Important**: Only include direct dependency changes in the commit message, not indirect ones.

This task updates Go module dependencies and ensures they compile correctly with Bazel.
