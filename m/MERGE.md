# Tilt Fork: Generic Orchestration Tool

This fork transforms Tilt from a Kubernetes/Docker-focused development tool into a **generic orchestration tool** that runs other tools without deep knowledge of specific platforms.

## Philosophy

The goal is to make Tilt a lightweight orchestration layer that:
- Runs arbitrary commands and tools
- Watches files for changes
- Manages local processes
- Provides a UI for monitoring
- Stays agnostic to Docker, Kubernetes, or any specific platform

Users can integrate their own build tools, deployment tools, and platforms via `local_resource()` and custom commands.

## What Was Removed

### Docker Support (Phase 1)
- `tilt/internal/docker/` - Docker client
- `tilt/internal/dockerfile/` - Dockerfile parsing
- `tilt/internal/dockerignore/` - .dockerignore processing
- `docker_build()`, `custom_build()` Tiltfile functions
- Docker image building, pushing, pruning
- Buildkit integration
- `tilt docker` and `tilt docker-prune` CLI commands

### Kubernetes Support (Phase 2)
- `tilt/internal/k8s/` - Kubernetes client and utilities
- `tilt/internal/controllers/core/kubernetesapply/` - K8s apply controller
- `tilt/internal/controllers/core/kubernetesdiscovery/` - K8s discovery
- `tilt/internal/controllers/core/podlogstream/` - Pod log streaming
- `tilt/internal/controllers/core/portforward/` - Port forwarding
- `tilt/internal/controllers/core/cluster/` - Cluster management
- `tilt/internal/engine/k8swatch/` - K8s resource watching
- `tilt/internal/engine/k8srollout/` - K8s rollout tracking
- `k8s_yaml()`, `k8s_resource()`, `k8s_custom_deploy()` Tiltfile functions
- Kubernetes API types (KubernetesApply, KubernetesDiscovery, Cluster, etc.)

### Container Support
- `tilt/internal/container/` - Container references and registry
- `tilt/internal/containerupdate/` - Container live updates
- `tilt/internal/controllers/core/liveupdate/` - Live update controller
- `tilt/internal/store/liveupdates/` - Live update state
- Live update Tiltfile functions

### Image Building
- `tilt/internal/build/` - Image building infrastructure
- `tilt/internal/engine/buildcontrol/` - Build orchestration
- `tilt/internal/controllers/core/dockerimage/` - Docker image controller
- `tilt/internal/controllers/core/cmdimage/` - Custom image controller
- `tilt/internal/controllers/core/imagemap/` - Image mapping
- Image-related store packages and API types

### Integration Tests
- All tests in `tilt/integration/` that depended on Docker/K8s

## What Remains

### Core Orchestration
- **File watching** - `tilt/internal/watch/`, `tilt/internal/controllers/core/filewatch/`
- **Local resources** - `local_resource()` for running commands
- **Command execution** - `tilt/internal/controllers/core/cmd/`
- **Process management** - `tilt/internal/localexec/`

### Tiltfile
- **Configuration** - `tilt/internal/tiltfile/config/`
- **Extensions** - `tilt/internal/tiltfile/tiltextension/`
- **File I/O** - `tilt/internal/tiltfile/io/`, `tilt/internal/tiltfile/encoding/`
- **Git integration** - `tilt/internal/tiltfile/git/`
- **OS utilities** - `tilt/internal/tiltfile/os/`
- **Watch settings** - `tilt/internal/tiltfile/watch/`

### UI
- **Terminal UI (HUD)** - `tilt/internal/hud/`
- **Web UI server** - `tilt/internal/hud/server/`
- **UI resources** - `tilt/internal/controllers/core/uiresource/`
- **UI buttons** - `tilt/internal/controllers/core/uibutton/`

### Infrastructure
- **Store/State** - `tilt/internal/store/`
- **Engine** - `tilt/internal/engine/`
- **CLI** - `tilt/internal/cli/`
- **Analytics** - `tilt/internal/analytics/`
- **Logging** - `tilt/pkg/logger/`

### API Types (Remaining)
- `Cmd` - Command execution
- `ConfigMap` - Configuration
- `FileWatch` - File watching
- `Extension` / `ExtensionRepo` - Extensions
- `Session` - Tilt session
- `Tiltfile` - Tiltfile configuration
- `UIResource` / `UIButton` / `UISession` - UI elements
- `ToggleButton` - Toggle controls

## Usage After Refactor

The refactored Tilt focuses on `local_resource()` for all orchestration:

```python
# Run a build tool
local_resource(
    'build',
    cmd='make build',
    deps=['src/'],
)

# Run tests on file changes
local_resource(
    'test',
    cmd='go test ./...',
    deps=['**/*.go'],
    auto_init=False,
)

# Start a development server
local_resource(
    'server',
    serve_cmd='./bin/server',
    deps=['bin/server'],
)

# Deploy using any tool
local_resource(
    'deploy',
    cmd='kubectl apply -f manifests/',
    resource_deps=['build'],
)
```

## Build Status

**Status**: Not yet compiling - imports need cleanup

The refactoring removed many packages, and remaining code still imports them. Next steps:
1. Fix import errors in remaining files
2. Update wire dependency injection
3. Regenerate protobuf/generated files
4. Run tests
