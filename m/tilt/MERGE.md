# Tilt Module Merge Documentation

This document describes the process of merging the tilt Go module into the parent `github.com/defn/dev/m` module and enabling Bazel builds.

## Background

The tilt project was originally forked as a standalone Go module at `github.com/defn/dev/m/tilt` with its own `go.mod`, `go.sum`, and `vendor/` directory. This caused issues with Bazel builds because:

1. Gazelle's `go_deps` extension only supports a single `go.mod` file via `from_file`
2. The vendored dependencies were duplicating what Bazel could cache
3. Proto dependencies in external modules had complex build requirements

## Changes Made

### 1. Removed Vendor Directory

**Why:** The vendor directory was 106 MB with 477 packages. Most were there for caching/reproducibility, not because they were forks. Bazel handles caching better.

**What was removed:**
- `tilt/vendor/` - Entire directory (9,086 files)
- Only kept `tilt/vendor/modules.txt` temporarily, then removed entirely

**Files modified:**
- `tilt/Makefile` - Removed all `-mod vendor` and `-mod=vendor` flags, removed `vendor` target

### 2. Merged go.mod Files

**Why:** Gazelle only supports one `go.mod` per workspace. Having tilt as a separate module prevented Bazel from resolving dependencies correctly.

**Files deleted:**
- `tilt/go.mod`
- `tilt/go.sum`

**Files modified:**
- `/m/go.work` - Removed `./tilt` entry:
  ```go
  go 1.25.5
  use (
      .
      ./cv
  )
  ```

- `/m/go.mod` - Added all tilt dependencies. Key additions:
  ```go
  require (
      // ... existing deps ...

      // Tilt dependencies
      al.essio.dev/pkg/shellescape v1.6.0
      github.com/adrg/xdg v0.5.3
      github.com/akutz/memconn v0.1.0
      github.com/blang/semver v3.5.1+incompatible
      github.com/compose-spec/compose-go/v2 v2.10.0
      github.com/distribution/reference v0.6.0
      github.com/docker/cli v28.5.2+incompatible
      github.com/docker/docker v28.5.2+incompatible
      github.com/docker/go-connections v0.6.0
      github.com/docker/go-units v0.5.0
      github.com/fatih/color v1.18.0
      github.com/fsnotify/fsevents v0.2.0
      github.com/gdamore/tcell v1.4.1
      github.com/go-logr/logr v1.4.3
      github.com/gogo/protobuf v1.3.2
      github.com/golang/protobuf v1.5.4
      github.com/google/go-cmp v0.7.0
      github.com/google/uuid v1.6.0
      github.com/google/wire v0.7.0
      github.com/gorilla/mux v1.8.1
      github.com/gorilla/websocket v1.5.4-0.20250319132907-e064f32e3674
      github.com/grpc-ecosystem/grpc-gateway v1.16.0
      github.com/jonboulle/clockwork v0.5.0
      github.com/json-iterator/go v1.1.12
      github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51
      github.com/looplab/tarjan v0.1.0
      github.com/mattn/go-colorable v0.1.14
      github.com/mattn/go-isatty v0.0.20
      github.com/mattn/go-jsonpointer v0.0.1
      github.com/mattn/go-tty v0.0.7
      github.com/moby/buildkit v0.26.2
      github.com/modern-go/reflect2 v1.0.3-0.20250322232337-35a7c28c31ee
      github.com/opencontainers/go-digest v1.0.0
      github.com/pkg/browser v0.0.0-20240102092130-5ac0b6a4141c
      github.com/pkg/errors v0.9.1
      github.com/rivo/tview v0.42.0
      github.com/schollz/closestmatch v2.1.0+incompatible
      github.com/spf13/afero v1.15.0
      github.com/spf13/pflag v1.0.10
      github.com/stretchr/testify v1.11.1
      github.com/tilt-dev/clusterid v0.1.6
      github.com/tilt-dev/dockerignore v0.1.1
      github.com/tilt-dev/fsnotify v1.4.7
      github.com/tilt-dev/go-get v0.2.3
      github.com/tilt-dev/localregistry-go v0.0.0-20201021185044-ffc4c827f097
      github.com/tilt-dev/probe v0.3.1
      github.com/tilt-dev/starlark-lsp v0.0.0-20240730211532-5689e7e8a3aa
      github.com/tilt-dev/tilt-apiserver v0.16.1
      github.com/tilt-dev/wmclient v0.0.0-20201109174454-1839d0355fbc
      github.com/tonistiigi/fsutil v0.0.0-20250605211040-586307ad452f
      github.com/tonistiigi/units v0.0.0-20180711220420-6950e57a87ea
      github.com/whilp/git-urls v1.0.0
      go.lsp.dev/protocol v0.12.0
      go.lsp.dev/uri v0.3.0
      go.opentelemetry.io/otel v1.38.0
      go.opentelemetry.io/otel/sdk v1.38.0
      go.opentelemetry.io/otel/trace v1.38.0
      go.starlark.net v0.0.0-20251109183026-be02852a5e1f
      go.uber.org/atomic v1.11.0
      golang.org/x/exp v0.0.0-20251125195548-87e1e737ad39
      golang.org/x/mod v0.30.0
      golang.org/x/sync v0.18.0
      golang.org/x/term v0.37.0
      golang.org/x/xerrors v0.0.0-20231012003039-104605ab7028
      google.golang.org/genproto/googleapis/api v0.0.0-20251202230838-ff82c1b0f217
      google.golang.org/grpc v1.77.0
      google.golang.org/protobuf v1.36.10
      gopkg.in/d4l3k/messagediff.v1 v1.2.1
      gopkg.in/yaml.v2 v2.4.0
      helm.sh/helm/v3 v3.19.2
      k8s.io/api v0.34.2
      k8s.io/apimachinery v0.34.2
      k8s.io/apiserver v0.34.2
      k8s.io/cli-runtime v0.34.2
      k8s.io/client-go v0.34.2
      k8s.io/code-generator v0.34.2
      k8s.io/klog/v2 v2.130.1
      k8s.io/kube-openapi v0.0.0-20251125145642-4e65d59e963e
      k8s.io/kubectl v0.34.2
      k8s.io/utils v0.0.0-20251002143259-bc988d571ff4
      sigs.k8s.io/controller-runtime v0.22.4
      sigs.k8s.io/kustomize/api v0.21.0
      sigs.k8s.io/yaml v1.6.0
  )
  ```

### 3. Added Replace Directives

**Why:** Some dependencies have custom forks or module path mismatches that need to be resolved.

**Added to `/m/go.mod`:**
```go
replace (
    github.com/pkg/browser => github.com/tilt-dev/browser v0.0.1
    k8s.io/apimachinery => github.com/tilt-dev/apimachinery v0.34.0-tilt-20250928
)
```

**Reasoning:**
- `github.com/pkg/browser` - Tilt uses a custom fork `github.com/tilt-dev/browser` with modifications
- `k8s.io/apimachinery` - Tilt uses a custom fork `github.com/tilt-dev/apimachinery` with Tilt-specific changes (the `v0.34.0-tilt-20250928` tag)

### 4. Added Exclude Directives

**Why:** The `google.golang.org/genproto` package was split into separate modules (`googleapis/api`, `googleapis/rpc`). Old versions of genproto conflict with the new split modules, causing "ambiguous import" errors.

**Added to `/m/go.mod`:**
```go
exclude (
    google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8
    google.golang.org/genproto v0.0.0-20190307195333-5fe7a883aa19
    google.golang.org/genproto v0.0.0-20190418145605-e7d98fc518a7
    google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55
    google.golang.org/genproto v0.0.0-20200513103714-09dca8ec2884
    google.golang.org/genproto v0.0.0-20230223222841-637eb2293923
)
```

**Reasoning:** These old monolithic genproto versions were being pulled in transitively by various dependencies (grpc-gateway v1, buildkit, etcd, etc.). Excluding them forces Go to resolve to the newer split modules.

### 5. Fixed Import Paths in Tilt Code

**Why:** The `github.com/alessio/shellescape` module has moved to `al.essio.dev/pkg/shellescape`. The module declares its path as the new one, but old code still imports the old path.

**Files modified:**
- `tilt/internal/cli/args_test.go`:
  ```go
  // Changed from:
  "github.com/alessio/shellescape"
  // To:
  "al.essio.dev/pkg/shellescape"
  ```

- `tilt/internal/tiltfile/shlex/shlex.go`:
  ```go
  // Changed from:
  "github.com/alessio/shellescape"
  // To:
  "al.essio.dev/pkg/shellescape"
  ```

### 6. Removed kubectl explain Command

**Why:** The `k8s.io/kubectl/pkg/cmd/explain` package depends on `k8s.io/kubectl/pkg/explain/v2`, which uses `//go:embed` with glob patterns (`templates/*.tmpl`). Gazelle doesn't properly handle `go:embed` with globs in external modules, causing build failures.

**Files deleted:**
- `tilt/internal/cli/explain.go`
- `tilt/internal/cli/explain_test.go`

**Files modified:**
- `tilt/internal/cli/cli.go` - Removed the explain command registration:
  ```go
  // Removed this line:
  addCommand(rootCmd, newExplainCmd(streams))
  ```

**Reasoning:** The fork will diverge significantly from upstream tilt, so removing problematic features is acceptable. This completely removes the explain command rather than stubbing it, eliminating the kubectl dependency issues.

### 7. Updated .bazelignore

**Why:** Removed tilt from bazelignore so Bazel would process its BUILD files.

**File modified:** `/m/.bazelignore`

```
# Before:
k3d
tilt

# After:
k3d
```

### 8. Updated MODULE.bazel with Gazelle Overrides

**Why:** Many external Go modules with proto files have broken Bazel builds because:
1. They reference proto dependencies that don't have BUILD files
2. They use `//go:embed` with glob patterns that Gazelle doesn't handle
3. They have internal package dependencies that Gazelle doesn't resolve

**Added to `/m/MODULE.bazel`:**

```starlark
# Override modules with proto files to not build protos (use pre-generated .pb.go files)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "github.com/moby/buildkit",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "github.com/tonistiigi/fsutil",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "github.com/containerd/containerd/v2",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "github.com/containerd/containerd/api",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "github.com/containerd/ttrpc",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "go.etcd.io/etcd/api/v3",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "go.etcd.io/etcd/client/v3",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "go.opentelemetry.io/proto/otlp",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
    ],
    path = "sigs.k8s.io/apiserver-network-proxy/konnectivity-client",
)
go_deps.gazelle_override(
    directives = [
        "gazelle:proto disable",
        # Resolve imports for internal package
        "gazelle:resolve go github.com/grpc-ecosystem/grpc-gateway/internal @com_github_grpc_ecosystem_grpc_gateway//internal:go_default_library",
    ],
    path = "github.com/grpc-ecosystem/grpc-gateway",
)
```

**Reasoning for each override:**

- **moby/buildkit**: Has proto files that reference `google/rpc` without proper BUILD files
- **tonistiigi/fsutil**: Has proto files with internal dependencies
- **containerd/containerd/v2** and **containerd/api**: Proto files with complex dependencies
- **containerd/ttrpc**: Proto files that fail to build
- **go.etcd.io/etcd/api/v3** and **client/v3**: Proto files referencing googleapis
- **go.opentelemetry.io/proto/otlp**: Proto files with external dependencies
- **sigs.k8s.io/apiserver-network-proxy/konnectivity-client**: Proto files that generate incomplete code
- **grpc-ecosystem/grpc-gateway**: Proto files plus needs internal package resolution

### 9. Fixed BUILD.bazel Files for grpc-gateway Runtime

**Why:** The generated BUILD.bazel files reference `@com_github_grpc_ecosystem_grpc_gateway//runtime` but the actual target is named `go_default_library`.

**Files modified:**
- `tilt/pkg/webview/BUILD.bazel`
- `tilt/internal/cli/BUILD.bazel`
- `tilt/internal/cloud/BUILD.bazel`
- `tilt/internal/hud/server/BUILD.bazel`

**Change:**
```starlark
# Changed from:
"@com_github_grpc_ecosystem_grpc_gateway//runtime"
# To:
"@com_github_grpc_ecosystem_grpc_gateway//runtime:go_default_library"
```

### 10. Updated pkg/webview/BUILD.bazel

**Why:** The original BUILD.bazel had proto_library and go_proto_library rules that referenced incorrect paths (e.g., `//pkg/apis/core/v1alpha1` instead of `//tilt/pkg/apis/core/v1alpha1`). Also, proto generation was failing.

**File modified:** `tilt/pkg/webview/BUILD.bazel`

**Changed to use pre-generated .pb.go files:**
```starlark
load("@io_bazel_rules_go//go:def.bzl", "go_library", "go_test")

# gazelle:ignore
# NOTE: Proto generation is disabled - using pre-generated .pb.go files instead
# The original tilt project had proto files at the root, but now we're under tilt/
# which would require updating all proto import paths.

go_library(
    name = "webview",
    srcs = [
        "log.pb.go",
        "view.pb.go",
    ],
    importpath = "github.com/defn/dev/m/tilt/pkg/webview",
    visibility = ["//visibility:public"],
    deps = [
        "//tilt/pkg/apis/core/v1alpha1",
        "@com_github_grpc_ecosystem_grpc_gateway//runtime:go_default_library",
        "@org_golang_google_genproto_googleapis_api//annotations",
        "@org_golang_google_grpc//:grpc",
        "@org_golang_google_grpc//codes",
        "@org_golang_google_grpc//grpclog",
        "@org_golang_google_grpc//metadata",
        "@org_golang_google_grpc//status",
        "@org_golang_google_protobuf//proto",
        "@org_golang_google_protobuf//reflect/protoreflect",
        "@org_golang_google_protobuf//runtime/protoimpl",
        "@org_golang_google_protobuf//types/known/timestamppb",
    ],
)

go_test(
    name = "webview_test",
    srcs = ["view_test.go"],
    embed = [":webview"],
    deps = [
        "//tilt/internal/timecmp",
        "//tilt/pkg/apis/core/v1alpha1",
        "@com_github_grpc_ecosystem_grpc_gateway//runtime:go_default_library",
        "@com_github_stretchr_testify//assert",
        "@com_github_stretchr_testify//require",
        "@io_k8s_apimachinery//pkg/apis/meta/v1:meta",
    ],
)
```

## Build Verification

After all changes:

```bash
# Go build works
$ go build ./tilt/...
# (no output = success)

# Bazel build works
$ bazel build //tilt/...
INFO: Found 289 targets...
INFO: Build completed successfully, 557 total actions

# Tilt binary works
$ bazel-bin/tilt/cmd/tilt/tilt_/tilt version
v0.36.0-dev, built 2025-12-07
```

## Future Considerations

1. **Proto generation**: Currently disabled for tilt protos. If protos need to be regenerated, the import paths in the .proto files would need to be updated to include `tilt/` prefix, or a proto strip prefix would need to be configured.

2. **Upstream sync**: This fork will diverge significantly. Syncing with upstream tilt would require re-applying these changes.

3. **gazelle:ignore**: The `tilt/pkg/webview/BUILD.bazel` file has `# gazelle:ignore` to prevent gazelle from overwriting the manual proto fix. Running `bazel run //:gazelle` is safe.

## Commands Used

```bash
# Remove vendor
rm -rf tilt/vendor

# Update go.mod
go mod tidy

# Run gazelle to generate BUILD files
bazel run //:gazelle

# Update MODULE.bazel use_repo calls
bazel mod tidy

# Build tilt
bazel build //tilt/...

# Build specific binary
bazel build //tilt/cmd/tilt:tilt
```
