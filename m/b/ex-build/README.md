# Example: Complete Build Pipeline

This demonstrates combining genrules and macros in a realistic build pipeline for configuration management.

## Architecture

```
Raw Config (JSON)
    ↓ [genrule: format_json.sh]
Formatted Config
    ↓ [genrule: validate_json.sh]
Validation Report
    ↓
Config Directory
    ↓ [macro: bundle_configs]
Environment Bundles (prod, dev)
    ↓ [macro: bundle_info]
Bundle Metadata
```

## Scripts

**Genrule Scripts** (used directly):
- `format_json.sh` - Formats JSON with configurable indentation
- `validate_json.sh` - Validates JSON and extracts schema info

**Macro Scripts** (wrapped in `.bzl`):
- `bundle_configs.sh` - Creates environment-specific config bundles
- `extract_bundle_info.sh` - Extracts bundle metadata

## Usage Patterns

### Direct Genrule Usage

For one-off transformations or when you need fine-grained control:

```python
genrule(
    name = "formatted_config",
    tools = [":format_json_sh", "//b/lib:lib_sh"],
    srcs = [":sample_config"],
    outs = ["formatted_config.json"],
    cmd = "$(location :format_json_sh) input=$(location :sample_config) indent=4 $@",
)
```

### Macro Usage

For reusable operations you'll call multiple times:

```python
load(":build_macros.bzl", "bundle_configs")

bundle_configs(
    name = "prod_bundle",
    config_dir = ":config_dir",
    env = "production",
)

bundle_configs(
    name = "dev_bundle",
    config_dir = ":config_dir",
    env = "development",
)
```

## Try It

```bash
# Build entire pipeline
bazel build //b/ex-build:all_outputs

# View formatted config
cat bazel-bin/b/ex-build/formatted_config.json

# View validation report
cat bazel-bin/b/ex-build/validation.txt

# Inspect bundles
tar tzf bazel-bin/b/ex-build/prod_bundle.tar.gz
cat bazel-bin/b/ex-build/prod_bundle_info.txt

# Compare dev vs prod bundles
diff -u \
    <(tar tzf bazel-bin/b/ex-build/prod_bundle.tar.gz) \
    <(tar tzf bazel-bin/b/ex-build/dev_bundle.tar.gz)
```

## When to Use Genrules vs Macros

**Use Genrules Directly When:**
- One-off transformation unique to this BUILD file
- Need full control over cmd construction
- Debugging a new script before wrapping in macro

**Use Macros When:**
- Operation repeated across multiple BUILD files
- Want to hide implementation details from users
- Need consistent defaults across the monorepo
- Planning to auto-generate call sites

## Composition Benefits

Because everything is a Bazel target:

1. **Dependency Tracking**
   - Change `config.json` → Bazel rebuilds bundles
   - Bazel knows validation depends on formatting

2. **Caching**
   - Same `config_dir` hash = reuse bundle from cache
   - CI shares cached bundles with local builds

3. **Parallelism**
   - Bazel builds `prod_bundle` and `dev_bundle` concurrently
   - Independent validation and formatting run in parallel

4. **Incremental Builds**
   - Modify only validation script → only validation reruns
   - Config unchanged → bundles come from cache

## Auto-Generation Potential

This structure is highly regular and can be auto-generated from:

```yaml
# build_manifest.yaml
scripts:
  genrules:
    - name: format_json
      args: [input, indent]
    - name: validate_json
      args: [input]

  macros:
    - name: bundle_configs
      script: bundle_configs
      args: [config_dir, env]
    - name: bundle_info
      script: extract_bundle_info
      args: [bundle]

pipeline:
  - genrule: format_json
    input: sample_config
  - genrule: validate_json
    input: formatted_config
  - macro: bundle_configs
    config_dir: config_dir
    instances: [prod, dev]
```

Generate:
- Bash script stubs
- BUILD.bazel filegroups
- .bzl macros
- BUILD.bazel pipeline targets
