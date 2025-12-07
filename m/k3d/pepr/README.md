# Pepr Script Operator

A Kubernetes operator built with [Pepr](https://pepr.dev) that executes shell scripts defined as Custom Resources.

## Overview

This operator watches for `Script` custom resources in the `defn` namespace and executes the specified shell script on the local machine, storing the output in a ConfigMap.

**Note:** This operator runs outside of Kubernetes (on your local machine) with access to the cluster API. It's a developer automation tool for controlling Kubernetes from your workstation, not a production-ready in-cluster operator for platform use.

## Project Structure

```
.
├── pepr.ts                 # Pepr module entrypoint
├── pepr.yaml               # Example Script resources
├── capabilities/
│   ├── defn.ts             # Operator capability (watches, handlers)
│   └── crd/
│       ├── api.cue         # CRD template in CUE
│       ├── api.Script.cue  # Script schema definition
│       ├── crd.Script.yaml # Generated CRD manifest
│       └── Script.d.ts     # Generated TypeScript types
├── Tiltfile                # Tilt dev environment config
└── .mise/tasks/            # Mise task runner scripts
    ├── build               # Build all generated artifacts
    ├── init                # Initialize namespace and CRDs
    ├── serve               # Run pepr dev server
    └── up                  # Start tilt environment
```

## Script CRD

The `Script` custom resource defines a shell script to execute:

```yaml
apiVersion: defn.dev/v1
kind: Script
metadata:
  name: hello
  namespace: defn
spec:
  script: id -a # Required: shell command to run
  workdir: /tmp # Required: working directory
  user: ubuntu # Optional: run as user
  group: staff # Optional: run as group
  umask: "022" # Optional: file creation mask
  result: "" # Optional: execution result (set by operator)
```

## Development

### Prerequisites

- Node.js >= 25.0.0
- kubectl configured for your cluster
- [mise](https://mise.jdx.dev) task runner
- [Tilt](https://tilt.dev) for local development

### Tasks

```bash
# Build all generated artifacts (CRDs, TypeScript types)
mise run build

# Initialize namespace and apply CRDs
mise run init

# Start the Pepr dev server
mise run serve

# Start full Tilt environment (runs init + tilt up)
mise run up
```

### Build

```bash
mise run build
```

This runs all build tasks:

- **Regenerate CRDs** - Generates `crd.Script.yaml` (Kubernetes CRD) and `Script.d.ts` (TypeScript types) from the CUE schema in `api.Script.cue`. See [capabilities/crd/README.md](capabilities/crd/README.md) for details.

## How It Works

1. The operator watches for `Script` resources in the `defn` namespace
2. On create/update, it executes the specified script
3. Script output is stored in a ConfigMap with the same name
4. On delete, the corresponding ConfigMap is cleaned up
