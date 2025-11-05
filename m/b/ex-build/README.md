# Example: Build Client Composing Genrules and Macros

This demonstrates a realistic config build workflow by **importing and composing** tools from other examples:

- **Genrules from [//b/ex-genrule](../ex-genrule/)**: `uppercase.sh`, `word_count.sh`
- **Macros from [//b/ex-macros](../ex-macros/)**: `archive_directory()`, `archive_info()`

**No scripts defined here** - this is a pure client showing how to use the bash-to-Bazel system at scale.

## Workflow

```
Raw Config Files (.conf)
  ↓ [genrule: //b/ex-genrule:uppercase_sh]
Normalized Configs (UPPERCASE)
  ↓ [genrule: //b/ex-genrule:word_count_sh]
Size Reports
  ↓ [macro: archive_directory from //b/ex-macros]
Deployment Bundles (prod, staging)
  ↓ [macro: archive_info from //b/ex-macros]
Bundle Metadata
```

## Build

```bash
# Build entire config pipeline
bazel build //b/ex-build:all_outputs

# Build specific outputs
bazel build //b/ex-build:production_config_bundle
bazel build //b/ex-build:staging_bundle_info
```

## View Outputs

```bash
# Normalized configs
cat bazel-bin/b/ex-build/normalized/app.conf
# Output: APPLICATION CONFIGURATION SETTINGS

# Size report
cat bazel-bin/b/ex-build/reports/app_size.txt
# Output: 3

# Production bundle contents
tar tzf bazel-bin/b/ex-build/production_config_bundle.tar.gz
# Output:
# ./prod-configs/app.conf
# ./prod-configs/database.conf
# ./prod-configs/cache.conf

# Bundle metadata
cat bazel-bin/b/ex-build/production_bundle_info.txt
```

## Key Patterns Demonstrated

### 1. Importing Genrule Scripts from Another Package

```python
genrule(
    name = "normalized_app_conf",
    tools = [
        "//b/ex-genrule:uppercase_sh",  # Cross-package import
        "//b/lib:lib_sh",
    ],
    cmd = "$(location //b/ex-genrule:uppercase_sh) input=... $@",
)
```

The `//b/ex-genrule:uppercase_sh` reference imports the script filegroup from the ex-genrule package.

### 2. Importing Macros from Another Package

```python
load("//b/ex-macros:macros.bzl", "archive_directory", "archive_info")

archive_directory(
    name = "production_config_bundle",
    dir = ":normalized_configs",
    prefix = "prod-configs",
)
```

The `load()` statement imports macro functions from the ex-macros package.

### 3. Composing in a Dependency Graph

```
raw_configs
  → normalized_app_conf (uses ex-genrule:uppercase_sh)
  → normalized_database_conf (uses ex-genrule:uppercase_sh)
  → normalized_cache_conf (uses ex-genrule:uppercase_sh)
    → normalized_configs (filegroup)
      → production_config_bundle (uses ex-macros:archive_directory)
        → production_bundle_info (uses ex-macros:archive_info)
```

Bazel automatically tracks dependencies across packages and rebuilds only what changed.

### 4. Multiple File Selection with `set --`

```bash
cmd = """
    set -- $(locations :raw_configs)  # $$1=app.conf, $$2=database.conf, $$3=cache.conf
    $(location //b/ex-genrule:uppercase_sh) input=$$1 $@
"""
```

When a target produces multiple files, `$(locations)` expands to all of them. Use shell positional parameters to select specific files.

## Why This Matters

This example shows **real-world Bazel usage**:

1. **Tooling packages** (`ex-genrule`, `ex-macros`) provide reusable scripts and macros
2. **Client packages** (`ex-build`) import and compose them without duplication
3. **No copy-paste** - fix a bug in `uppercase.sh` once, all clients benefit
4. **Discoverability** - Engineers search for `archive_directory` macro, not raw genrules
5. **Caching works across packages** - CI builds bundle once, all environments reuse it

## Compared to Raw Bash

**Without Bazel:**

```bash
# scripts/build-configs.sh
#!/bin/bash
tr '[:lower:]' '[:upper:]' < raw/app.conf > normalized/app.conf
tr '[:lower:]' '[:upper:]' < raw/database.conf > normalized/database.conf
tar czf prod-bundle.tar.gz normalized/*
```

**Problems:**

- No incremental builds (always runs everything)
- No caching (CI rebuilds identical bundles)
- Hard to reuse (copy-paste uppercase logic)
- No dependency tracking (did you update raw/app.conf?)

**With This System:**

```python
# BUILD.bazel
load("//b/ex-macros:macros.bzl", "archive_directory")

genrule(
    name = "normalized_app_conf",
    tools = ["//b/ex-genrule:uppercase_sh"],
    ...
)

archive_directory(name = "prod_bundle", dir = ":normalized")
```

**Benefits:**

- Incremental (only rebuilds changed files)
- Cached (team shares artifacts)
- Reusable (import `uppercase_sh` anywhere)
- Tracked (Bazel knows raw → normalized → bundle)

## Next Steps

1. **Add more tools** - Create `//b/ex-json`, `//b/ex-yaml` packages
2. **Import in your projects** - Use these macros in `//myapp/BUILD.bazel`
3. **Build pipelines** - Compose genrule → macro → genrule chains
4. **Share via remote cache** - Team members reuse your build outputs

See [../COOL.md](../COOL.md) for why this approach scales to large teams and monorepos.
