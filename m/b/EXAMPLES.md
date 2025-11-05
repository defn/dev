# Bash + Bazel Examples

Three working examples demonstrating lib.sh usage patterns with Bazel.

## Quick Test

```bash
b build  # Builds all 31 example targets
```

## 1. Genrules ([ex-genrule/](ex-genrule/))

**Scripts:** [uppercase.sh](ex-genrule/uppercase.sh), [word_count.sh](ex-genrule/word_count.sh)

Direct genrule invocations of bash scripts using lib.sh key-value arguments.

**Build:**

```bash
bazel build //b/ex-genrule:uppercase_output
bazel build //b/ex-genrule:chained_output  # uppercase → word_count
```

**View:**

```bash
cat bazel-bin/b/ex-genrule/uppercase.txt
# Output: HELLO WORLD FROM BAZEL GENRULE EXAMPLE

cat bazel-bin/b/ex-genrule/word_count.txt
# Output: 6
```

**Pattern:**

```python
genrule(
    tools = [":script_sh", "//b/lib:lib_sh"],
    cmd = "$(location :script_sh) input=$(location :data) $@",
)
```

Script receives:

- `in[input]` = path to data file
- `out` = output file path

## 2. Macros ([ex-macros/](ex-macros/))

**Scripts:** [create_archive.sh](ex-macros/create_archive.sh), [list_archive.sh](ex-macros/list_archive.sh)

Reusable Starlark macros wrapping bash scripts.

**Build:**

```bash
bazel build //b/ex-macros:my_archive
bazel build //b/ex-macros:archive_metadata
```

**View:**

```bash
tar tzf bazel-bin/b/ex-macros/my_archive.tar.gz
# Output:
# ./myproject/file1.txt
# ./myproject/file2.txt
# ./myproject/file3.txt

cat bazel-bin/b/ex-macros/archive_metadata.txt
# Shows archive size and contents
```

**Pattern:**

```python
# In BUILD.bazel
load("//b/ex-macros:macros.bzl", "archive_directory")

archive_directory(
    name = "my_archive",
    dir = ":source_files",
    prefix = "myproject",
)
```

Macro implementation hides genrule boilerplate:

```python
# In macros.bzl
def archive_directory(name, dir, prefix = None, visibility = None):
    script = Label("//b/ex-macros:create_archive_sh")
    native.genrule(
        name = name,
        tools = [script, "//b/lib:lib_sh"],
        srcs = [dir],
        cmd = "$(location {}) {} $@ $(locations {})".format(script, prefix_arg, dir),
        ...
    )
```

## 3. Build Client ([ex-build/](ex-build/))

**Scripts:** None - pure client importing from ex-genrule and ex-macros

This demonstrates **cross-package composition** - the real-world pattern of building tooling packages and client packages.

**Build:**

```bash
bazel build //b/ex-build:all_outputs
```

**Pipeline:**

```
raw_configs
  ↓ [genrule: //b/ex-genrule:uppercase_sh]
normalized_configs (uppercase text)
  ↓ [genrule: //b/ex-genrule:word_count_sh]
config_size_report
  ↓ [macro: //b/ex-macros:archive_directory]
production_config_bundle.tar.gz
staging_config_bundle.tar.gz
  ↓ [macro: //b/ex-macros:archive_info]
bundle metadata
```

**View:**

```bash
# Normalized configs
cat bazel-bin/b/ex-build/normalized/app.conf
# Output: APPLICATION CONFIGURATION SETTINGS

# Size report
cat bazel-bin/b/ex-build/reports/app_size.txt
# Output: 3

# Production bundle
tar tzf bazel-bin/b/ex-build/production_config_bundle.tar.gz
# Output: ./prod-configs/app.conf, database.conf, cache.conf

# Bundle info
cat bazel-bin/b/ex-build/production_bundle_info.txt
```

**Key Pattern - Importing Tools:**

```python
# Import macros from ex-macros
load("//b/ex-macros:macros.bzl", "archive_directory")

# Import genrule scripts from ex-genrule
genrule(
    tools = ["//b/ex-genrule:uppercase_sh"],
    cmd = "$(location //b/ex-genrule:uppercase_sh) input=... $@",
)
```

## Key Patterns

### Genrule with Multiple Files

When target outputs multiple files, use `$(locations)` and pass as positional args:

```python
genrule(
    cmd = "$(location :script) env=prod $@ $(locations :config_files)",
)
```

Script receives:

- `in[env]` = "prod"
- `out` = output file
- `args[@]` = array of config file paths

### lib.sh Argument Parsing

```bash
function main {
    local env="${in[env]:-production}"  # key=value args → in[]
    local out="${shome}/${out}"          # first positional → out

    for file in "${args[@]}"; do        # remaining args → args[]
        process "${file}"
    done
}

source b/lib/lib.sh  # Parses and calls main()
```

### Handling Directories in Bazel

Bazel can't pass directories, only files. To archive multiple files:

```bash
# ✗ Don't: try to glob from directory
cp -r "${dir}"/* destination/

# ✓ Do: iterate over file arguments
for file in "${args[@]}"; do
    cp "${file}" destination/
done
```

## What Gets Cached

Bazel caches based on input file hashes:

```bash
# First build
bazel build //b/ex-build:prod_bundle  # Runs scripts

# No changes
bazel build //b/ex-build:prod_bundle  # Instant (cached)

# Change config.json
echo '{"new":"data"}' > config.json
bazel build //b/ex-build:prod_bundle  # Rebuilds pipeline
```

## Auto-Generation Potential

These examples follow a regular structure that can be auto-generated:

1. **Script Template:**

   ```bash
   function main {
       local arg1="${in[arg1]}"
       local out="${shome}/${out}"
       # ... generated logic ...
   }
   source b/lib/lib.sh
   ```

2. **Macro Template:**

   ```python
   def tool_name(name, arg1, arg2=None, visibility=None):
       script = Label("//b/tool:script_sh")
       native.genrule(
           cmd = "$(location {}) arg1={} $@ ...".format(script, arg1),
           ...
       )
   ```

3. **BUILD Template:**
   ```python
   filegroup(name = "script_sh", srcs = ["script.sh"])
   ```

A generator could create all three from a manifest:

```yaml
tool: my_tool
script: process_data
args:
  - name: input
    type: file
  - name: format
    type: string
    default: json
output: "{name}.tar.gz"
```

Run: `bazel run //b:generate -- my_tool` → Creates scripts, macros, BUILD files

## Next Steps

1. **Copy a pattern** - Use ex-genrule for one-offs, ex-macros for reusables
2. **Integrate a tool** - Wrap your toolchain like the Nix/Earthly examples
3. **Build a pipeline** - Compose targets like ex-build
4. **Auto-generate** - Use the regular structure to generate boilerplate

# Bazel Package Structure for Bash Scripts

## Directory Organization

Scripts can (and should) live in subdirectories within a package:

```
b/ex-genrule/
├── BUILD.bazel          # Package definition
└── scripts/             # Scripts subdirectory
    ├── uppercase.sh
    └── word_count.sh

b/ex-macros/
├── BUILD.bazel
├── macros.bzl           # Macro definitions
└── scripts/             # Scripts subdirectory
    ├── create_archive.sh
    └── list_archive.sh
```

## How Bazel Packages Work

**A package is defined by a BUILD file** - not by directory boundaries. The package includes:

- All files in the BUILD file's directory
- All files in subdirectories (unless they have their own BUILD file)

## Referencing Scripts in Subdirectories

In your BUILD file, use relative paths:

```python
filegroup(
    name = "uppercase_sh",
    srcs = ["scripts/uppercase.sh"],  # Relative to BUILD.bazel
    visibility = ["//visibility:public"],
)
```

## Why Use Subdirectories?

### 1. Cleaner Organization

```
# Without subdirectories
b/ex-genrule/
├── BUILD.bazel
├── uppercase.sh
├── word_count.sh
├── reverse.sh
├── format.sh
├── validate.sh
└── transform.sh

# With subdirectories
b/ex-genrule/
├── BUILD.bazel
├── scripts/
│   ├── uppercase.sh
│   ├── word_count.sh
│   ├── reverse.sh
│   ├── format.sh
│   ├── validate.sh
│   └── transform.sh
└── tests/
    └── test_uppercase.sh
```

### 2. Separation of Concerns

```
b/my-tool/
├── BUILD.bazel
├── macros.bzl
├── scripts/           # Implementation
│   ├── build.sh
│   └── deploy.sh
├── configs/           # Configuration
│   └── defaults.yaml
└── docs/             # Documentation
    └── usage.md
```

### 3. Better for Large Packages

```
b/aws-tools/
├── BUILD.bazel
├── aws.bzl
├── scripts/
│   ├── ec2/
│   │   ├── create_instance.sh
│   │   └── terminate_instance.sh
│   ├── s3/
│   │   ├── upload.sh
│   │   └── sync.sh
│   └── lambda/
│       ├── deploy.sh
│       └── invoke.sh
└── templates/
    └── cloudformation/
```

## Patterns by Tool Type

### Simple Tools (1-2 scripts)

```
b/uppercase/
├── BUILD.bazel
└── uppercase.sh          # Fine to keep at top level
```

### Medium Tools (3-5 scripts)

```
b/json-tools/
├── BUILD.bazel
├── json.bzl
└── scripts/              # Group scripts together
    ├── format.sh
    ├── validate.sh
    └── transform.sh
```

### Complex Tools (6+ scripts)

```
b/deployment/
├── BUILD.bazel
├── deployment.bzl
├── scripts/
│   ├── build/
│   │   ├── docker.sh
│   │   └── helm.sh
│   └── deploy/
│       ├── staging.sh
│       └── production.sh
└── configs/
    └── environments/
```

## Glob Patterns

You can use glob to reference multiple scripts:

```python
filegroup(
    name = "all_scripts",
    srcs = glob(["scripts/**/*.sh"]),  # All .sh files in scripts/
)
```

## Cross-Package References Stay the Same

Subdirectories don't change how other packages reference your tools:

```python
# In //b/ex-build/BUILD.bazel
genrule(
    name = "normalize",
    tools = ["//b/ex-genrule:uppercase_sh"],  # Same reference
    cmd = "$(location //b/ex-genrule:uppercase_sh) input=... $@",
)
```

The internal structure (`scripts/uppercase.sh`) is hidden from consumers.

## Best Practices

1. **Use `scripts/` for bash files** - Makes it clear these are executables
2. **Use descriptive subdirectories** - `scripts/build/`, `scripts/test/`
3. **Keep BUILD files clean** - Separate scripts from BUILD logic
4. **Group related scripts** - e.g., all AWS scripts together
5. **Don't nest BUILD files** - Each BUILD creates a new package boundary

## Anti-Patterns

### ❌ Don't create nested packages unnecessarily

```
b/my-tool/
├── BUILD.bazel
└── scripts/
    └── BUILD.bazel      # Creates separate package, breaks references
```

### ❌ Don't use absolute paths in scripts

```bash
# Bad: Assumes specific location
source /home/ubuntu/m/b/lib/lib.sh

# Good: Relative to workspace
source b/lib/lib.sh
```

### ✓ Do use subdirectories for organization

```
b/my-tool/
├── BUILD.bazel
├── scripts/
│   ├── build.sh
│   └── deploy.sh
└── tests/
    └── test_build.sh
```

## Migration Example

If you have flat structure and want to add subdirectories:

```bash
# 1. Create subdirectory
mkdir -p b/my-tool/scripts

# 2. Move scripts
mv b/my-tool/*.sh b/my-tool/scripts/

# 3. Update BUILD.bazel
# Change: srcs = ["build.sh"]
# To:     srcs = ["scripts/build.sh"]

# 4. Test
bazel build //b/my-tool:all
```

No changes needed in packages that reference your tools!

## Summary

- **Scripts CAN live in subdirectories** ✓
- **Package = BUILD file + all subdirectories** (unless they have own BUILD)
- **Reference with relative paths**: `["scripts/tool.sh"]`
- **External references unchanged**: `"//b/my-tool:tool_sh"`
- **Best practice**: Use `scripts/` subdirectory for organization
