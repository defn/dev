# Nix Build Integration

This directory contains Bazel build rules for integrating Nix (a package manager and build system) into the build system. Nix provides reproducible builds and package management.

## Files

- `BUILD.bazel` - Bazel build configuration for Nix integration
- `flake_path.sh` - Script for resolving Nix flake paths
- `flake_store.sh` - Script for managing Nix store operations with flakes
- `flake_which.sh` - Script for locating executables in Nix flake environments
- `nix.bzl` - Bazel Starlark implementation of Nix build rules and macros

The Nix integration allows for reproducible dependency management and builds using the Nix ecosystem within Bazel.