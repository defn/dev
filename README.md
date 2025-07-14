# defn/dev

Monorepo for cloud integrated development environments.

## Features

- **Bazel**: Monorepo build tool
- **Buildkite**: CI/CD pipeline
- **CUE**: Monorepo configuration
- **Coder**: Coder workspaces in the browser for the IDE
- **Mise**: Tools, environment, and task management

## Machine Setup

This will allow you to create a Linux defn/dev environment.

Verify that Docker is running and accessible.

```
docker ps
```

If Docker is not installed, then install with brew.

```
brew install --cask docker
```

Start Docker and complete Docker setup.

Run the Linux container. If prompted, register the Linux container with Tailscale.

```
make up
```

## Quickstart

Build the monorepo, change directory to `m/` and run Bazel.

```
cd m
b build
```

The `main` branch build is [![Build status](https://badge.buildkite.com/879feda30e2616b22929338672877e85dfe82f60eb47df2e6a.svg?branch=main)](https://buildkite.com/defn/dev)

## Updates

These methods assume the latest repo is used.

At every start of a session update your tools with `make sync`. This also updates your home directory git repo.

## Supported Environments

- macOS
- Linux

Only `$HOME` is supported as the repo root. Getting the repo to work in
arbitrary directories is necessary to support Buildkite and devcontainers which
separate the operating user from the project.

---

## Repository Structure

### Core Directories
- **bin/** - Executable scripts and utilities
- **m/** - Main project workspace with build system and applications
- **.buildkite/** - CI/CD pipeline configuration
- **.github/** - GitHub workflows and repository configuration
- **docs/** - Project documentation

### Configuration Files
- **Makefile** - Project automation and system setup
- **Justfile** - Just command runner recipes
- **mise.toml** - Tool version management
- **.devcontainer.json** - Development container configuration
- **.gitignore** - Git ignore rules
- **.env.example** - Environment variables template

### Shell Configuration
- **.bash_profile** - Bash profile configuration
- **.bashrc** - Bash runtime configuration
- **.bashrc_path** - PATH configuration
- **.bash_entrypoint** - Container entrypoint script
- **.vimrc** - Vim editor configuration

### Development Tools
- **Brewfile** - Homebrew package definitions
- **.npmrc** - NPM configuration
- **.dockerignore** - Docker ignore rules
- **.earthlyignore** - Earthly ignore rules
- **.gitconfig.default** - Default Git configuration

### System Configuration
- **.ansible.cfg** - Ansible configuration
- **.direnvrc** - Direnv configuration
- **.direnvlib** - Direnv library functions
- **.gnupg2** - GPG configuration symlink
- **.password-store** - Password store symlink
- **.vscode** - VS Code configuration symlink

### Project Metadata
- **CHANGELOG.md** - Project changelog
- **CONTRIBUTING.md** - Contribution guidelines
- **LICENSE** - Project license
- **SECURITY.md** - Security policy
- **version.txt** - Version information
- **release-please-config.json** - Release automation configuration
