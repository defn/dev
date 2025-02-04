# defn.dev

Monorepo for cloud integrated development environments.

## Features

- **Bazel**: Monorepo build tool
- **Buildkite**: CI/CD pipeline
- **CUE**: Monorepo configuration
- **Coder**: Coder workspaces in the browser for the IDE
- **Mise**: Tools, environment, and task management

## Installation

Clone the repo to your `/home/ubuntu` directory. User must be named `ubuntu`. The process below will overwrite files typically customized by the user.

```
cd $HOME
git clone https://github.com/defn/dev dev
mv dev/.git .
rm -rf dev
git reset --hard
```

Open a new terminal or run a `bash` sub-shell to load the new `$HOME` configuration.

Then install the basic tools:

```
make install
```

## Quickstart

Build the monorepo, change directory to `m/` and run Bazel.

```
cd m
b build
```
