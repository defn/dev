# defn/dev

Monorepo for cloud integrated development environments.

## Features

- **Bazel**: Monorepo build tool
- **Buildkite**: CI/CD pipeline
- **CUE**: Monorepo configuration
- **Coder**: Coder workspaces in the browser for the IDE
- **Mise**: Tools, environment, and task management

## Installation

This repository has been tested and developed on Ubuntu 24.04 with the user `ubuntu` in home directory `/home/ubuntu`.

Clone the repo to your `/home/ubuntu` directory.  The process below will overwrite files typically customized by the user.

```
cd $HOME
git clone https://github.com/defn/dev dev
mv dev/.git .
rm -rf dev
git reset --hard
```

Then install the tool dependencies:
```
./install.sh
```

After install, use new terminal sessions to load the `$HOME` configuration with `defn/dev` configuration and tooling.

## Quickstart

Build the monorepo, change directory to `m/` and run Bazel.

```
cd m
b build
```

The `main` branch build is [![Build status](https://badge.buildkite.com/879feda30e2616b22929338672877e85dfe82f60eb47df2e6a.svg?branch=main)](https://buildkite.com/defn/dev)