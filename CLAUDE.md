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

- **Always check for upstream changes before executing any task**:
  1. Check if upstream git is newer than local with `git fetch` and `git status`
  2. If upstream is newer, automatically run `git pull` to get the latest changes
  3. Re-read CLAUDE.md after pulling
  4. Summarize any differences in the pulled changes (files modified, commits added, etc.)
  5. If CLAUDE.md or task instructions changed, highlight the specific differences
  6. **Always ask for user confirmation before proceeding with the task**, even if explicitly asked to run it
  7. Only execute the task after receiving confirmation
  8. This ensures users are aware of updates and prevents running tasks with outdated instructions
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

**Note**: When the user mentions "task" without qualification, it refers only to tasks documented in this CLAUDE.md file. For tasks defined in other tools (e.g., mise tasks, just recipes), the word "task" must be qualified, such as "mise task" or "just task".

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

### Task: upgrade

When asked to "run upgrade task" or similar, follow these steps:

1. Run `make sync` in $HOME directory
2. This command installs/updates system tools and configurations based on what's already in git
3. No files should be modified in the home directory
4. No commit is needed as this task is run purely for its side effects

**Note**: This task updates the local system environment to match the configuration stored in git. It ensures all tools, configurations, and system settings are properly synchronized.

### Task: coder login

When asked to "run coder login task" or similar, follow these steps:

1. Get the Coder URL from the environment variable: `$CODER_AGENT_URL_ORIGINAL`
2. Run `coder login` with that URL as an argument: `coder login $CODER_AGENT_URL_ORIGINAL`
3. Wait for the Coder login command to prompt for a token
4. Ask the user to provide the token to paste into the Coder login prompt
5. Complete the login process with the user-provided token

**Note**: This task authenticates the local Coder CLI with the Coder deployment. The user will need to obtain a token from their Coder dashboard to complete the login.

### Task: go sync

When asked to "run go sync task" or similar, follow these steps:

1. Get the current Go version from mise: `mise exec -- go version`
2. Extract the version number (e.g., "1.24.5") from the output
3. Update the following files to use this version:
   - `m/go.mod`: Update the `go` directive line
   - `m/cv/go.mod`: Update the `go` directive line
   - `m/go.work`: Update the `go` directive line
   - `.trunk/trunk.yaml`: Update the `go@` runtime version
   - `.trunk/trunk.yaml`: Update the `gofmt@` linter version to match
4. Run `trunk fmt` to format any modified files
5. Test the synchronized versions by running `b build` in the m directory
6. Stage and commit the synchronized versions:

   ```bash
   git add m/go.mod m/cv/go.mod m/go.work .trunk/trunk.yaml
   git commit -m "chore: sync Go version across all configuration files

   - Update all Go references to match mise version: [version]
   - Ensures consistency across go.mod, go.work, and trunk.yaml
   - Synchronizes development tooling with configured Go version

   🤖 Generated with [Claude Code](https://claude.ai/code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

**Note**: This task ensures all Go version references in the repository are synchronized with the version configured in mise, providing consistency across development, building, and tooling environments.

### Task: coder update template

When asked to "run coder update template [name]" or similar, follow these steps:

1. Change directory to m/coder/template: `cd m/coder/template`
2. Run the push command with the template name: `j push coder-defn-[name]-template`
   - Replace `[name]` with the parameter provided by the user
   - For example: `j push coder-defn-ssh-template` if the user specified "ssh"

**Note**: This task uploads/updates a Coder template. The template name parameter is required and will be inserted into the command as `coder-defn-[name]-template`.

### Task: upgrade all

When asked to "run upgrade all task" or similar, follow these steps:

1. Run the upgrade task to sync system tools and configurations
2. Run the mise upgrade task to update tool versions
3. Run the go sync task to synchronize Go versions
4. Run the go upgrade task to update Go dependencies

Specifically, execute these tasks in order:
1. **upgrade**: Run `make sync` in $HOME directory
2. **mise upgrade**: 
   - Run `make mise-list` in $HOME directory
   - Execute the suggested mise commands (if any)
   - Stage and commit the changed mise.toml files with version changes
3. **go sync**:
   - Get Go version: `mise exec -- go version`
   - Update go.mod files, go.work, and trunk.yaml with the version
   - Run `trunk fmt`
   - Test with `b build` in m directory
   - Stage and commit the synchronized files
4. **go upgrade**:
   - Change to m directory: `cd m`
   - Run `make upgrade`
   - Test with `b build`
   - Stage and commit go.mod and go.sum with direct dependency changes

**Note**: This comprehensive task ensures all development tools, dependencies, and version configurations are updated and synchronized across the entire repository. Each sub-task should complete successfully before proceeding to the next.

### Task: coder upgrade all

When asked to "run coder upgrade all task" or similar, follow these steps:

1. Run the coder update template ssh task
2. Run the coder update template docker task

Specifically, execute these tasks in order:
1. **coder update template ssh**: 
   - Change directory to m/coder/template: `cd m/coder/template`
   - Run: `j push coder-defn-ssh-template`
2. **coder update template docker**:
   - Change directory to m/coder/template: `cd m/coder/template`
   - Run: `j push coder-defn-docker-template`

**Note**: This task updates both SSH and Docker Coder templates, ensuring all template versions are current and deployed.

### Task: coder upgrade workspaces

When asked to "run coder upgrade workspaces task" or similar, follow these steps:

1. List all workspaces using `coder list`
2. For each workspace name in the output, run `coder update WORKSPACE`
3. Handle any errors gracefully and continue with remaining workspaces

Specifically, execute these steps:
1. **List workspaces**: Run `coder list` to get all workspace names
2. **Extract workspace names**: Parse the output to get individual workspace names
3. **Update each workspace**: For each workspace name, run `coder update [workspace-name]`
4. **Report results**: Summarize which workspaces were updated successfully and any that failed

**Note**: This task updates all existing workspaces to use the latest template versions. Workspaces that are stopped or in error states may need special handling.

### Task: coder delete tasks

When asked to "run coder delete tasks task" or similar, follow these steps:

1. List all workspaces using `coder list`
2. Filter workspaces whose names start with "task"
3. For each matching workspace that is not running, delete it without prompting

Specifically, execute these steps:
1. **List workspaces**: Run `coder list` to get all workspace names and statuses
2. **Filter task workspaces**: Identify workspaces whose names start with "task"
3. **Check status**: Only delete workspaces that are not in "running" state
4. **Delete workspaces**: For each matching workspace, run `coder delete --yes [workspace-name]`
5. **Report results**: Summarize which workspaces were deleted and any that were skipped

**Note**: This task cleans up temporary task workspaces that are no longer running. The `--yes` flag prevents interactive prompts during deletion.
