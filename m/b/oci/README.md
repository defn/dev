# OCI Container Build Rules

This directory contains Bazel build rules for working with OCI (Open Container Initiative) containers. These rules provide container image building, manipulation, and distribution capabilities.

## Files

- `BUILD.bazel` - Bazel build configuration for OCI container rules
- `oci.bzl` - Bazel Starlark implementation of OCI container build rules and macros
- `skopeo_copy.sh` - Script for copying container images using Skopeo

The OCI build rules enable building, pushing, and managing container images as part of the Bazel build system, supporting standard OCI container formats.