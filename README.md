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
