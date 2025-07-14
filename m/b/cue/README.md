# CUE Build Rules

This directory contains Bazel build rules for integrating CUE (a configuration language) into the build system. CUE provides data validation and configuration management capabilities.

## Files

- `BUILD.bazel` - Bazel build configuration for CUE rules
- `cue.bzl` - Bazel Starlark implementation of CUE build rules and macros

The CUE build integration allows for configuration validation, schema enforcement, and data transformation as part of the build process.