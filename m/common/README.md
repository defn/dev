# m/common/

Shared utilities, configurations, and reusable components used across the project.

## Contents

### Build Automation
- **Makefile** - Common deployment, versioning, and ArgoCD operations
- **Makefile.build** - Shared build rules for containers and charts
- **Tiltfile** - Common Tilt development environment configurations

### Just Recipes
- **aws.Justfile** - AWS account management utilities
- **bazel.Justfile** - Bazel build system helpers
- **github.Justfile** - Git/GitHub workflow utilities
- **gpg.Justfile** - GPG agent management
- **lib.Justfile** - HTTP server and utility functions
- **tilt.Justfile** - Tilt development environment recipes

### CUE Configurations
- **chart.cue** - Helm chart configuration schema
- **deploy.cue** - Deployment configuration definitions
- **deployment.cue** - Kubernetes deployment templates
- **ns.cue** - Namespace configuration
- **output.cue** - Output formatting utilities
- **service.cue** - Service configuration templates
- **value.cue** - Value processing utilities

This directory provides the foundational components that are imported and reused by various applications and services throughout the project, ensuring consistency and reducing duplication.