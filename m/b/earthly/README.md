# Earthly Build Integration

This directory contains Bazel build rules for integrating Earthly (a CI/CD framework) into the build system. Earthly provides containerized builds with a Docker-like syntax.

## Files

- `BUILD.bazel` - Bazel build configuration for Earthly integration
- `docker_load.sh` - Script for loading Docker images from Earthly builds
- `earthly.bzl` - Bazel Starlark implementation of Earthly build rules and macros
- `earthly_build.sh` - Script for executing Earthly builds

The Earthly integration enables containerized builds and CI/CD workflows to be executed as part of the Bazel build process.