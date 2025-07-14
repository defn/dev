# m/

Main project workspace containing the core development environment, build system, and application code.

## Contents

### Build System
- **BUILD.bazel** - Main Bazel build file
- **MODULE.bazel** - Bazel module definition
- **WORKSPACE.bazel** - Bazel workspace configuration
- **REPO.bazel** - Repository rules and dependencies
- **.bazelrc** - Bazel configuration
- **.bazelrc.user.example** - Example user Bazel configuration
- **.bazelversion** - Bazel version specification
- **.bazel_fix_commands.json** - Bazel fix command configurations

### Build Tools
- **Makefile** - Make build targets and project automation
- **Justfile** - Just command runner recipes
- **Tiltfile** - Tilt development environment configuration
- **Tiltfile.old** - Previous Tilt configuration

### Go Project
- **go.mod** - Go module definition
- **go.sum** - Go module checksums
- **go.work** - Go workspace configuration
- **go.work.sum** - Go workspace checksums

### Node.js Project
- **package.json** - Node.js dependencies and scripts
- **package-lock.json** - Locked Node.js dependencies

### Container & Deployment
- **Dockerfile** - Container build instructions
- **DOCKER-BUILDX.sh** - Docker buildx script
- **fly.toml** - Fly.io deployment configuration
- **entrypoint.sh** - Container entrypoint script

### Configuration
- **mise.toml** - Mise tool version management
- **m.cue** - Main CUE configuration
- **mm.cue** - Additional CUE configuration
- **mirrord.json** - Mirrord configuration
- **layout.kdl** - Zellij layout configuration
- **.env.example** - Environment variables template
- **.dockerignore** - Docker ignore rules
- **.gitignore** - Git ignore rules

### Documentation
- **CLAUDE.md** - Claude AI assistant instructions
- **CODE.md** - Code organization and conventions
- **NOTES.md** - Development notes
- **TODO** - Task list
- **TUTORIAL.md** - Project tutorial and guides

This workspace uses a polyglot development approach with Bazel as the primary build system, supporting Go, Node.js, and containerized applications.