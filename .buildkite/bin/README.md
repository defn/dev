# Buildkite Build Scripts

This directory contains Buildkite CI/CD pipeline build scripts for various project components.

## Directory Purpose

Houses build automation scripts used by Buildkite CI/CD pipelines to compile, test, and deploy different parts of the project. Each script handles specific build tasks for different platforms or components.

## Files

- `bazel-build.sh` - Bazel build script that sets up environment and runs Bazel build commands
- `cmd-build.sh` - Command binary build script for cross-platform Go binary compilation
- `deploy-cf-pages.sh` - Cloudflare Pages deployment script for web assets
- `home-build.sh` - Home directory build script for environment setup
- `nix-build.sh` - Nix build script for reproducible package builds
- `trunk-check.sh` - Trunk code quality check script for linting and formatting