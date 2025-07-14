# Infrastructure as Code

This directory contains infrastructure as code definitions using CDKTF (Cloud Development Kit for Terraform) and related tooling for managing multiple AWS accounts and environments.

## Files

- `BUILD.bazel` - Bazel build configuration
- `Dockerfile` - Container configuration for infrastructure tools
- `Justfile` - Task runner configuration
- `Makefile` - Build automation rules
- `OMG` - Operations management guide
- `Tiltfile` - Tilt development workflow configuration
- `cdktf.json` - CDKTF project configuration
- `flake.json` - Nix flake configuration
- `flake.lock` - Nix flake lock file
- `flake.nix` - Nix environment configuration
- `infra.Justfile` - Infrastructure-specific tasks
- `infra.cue` - CUE definitions for infrastructure
- `infra.go` - Go infrastructure code
- `mise.toml` - Development tool configuration
- `package-lock.json` - NPM lock file
- `package.json` - NPM package configuration
- `stacks` - Stack definitions file

## Subdirectories

- `cdktf.out/` - Generated Terraform code and stack outputs
- `node_modules/` - NPM dependencies