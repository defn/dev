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

## 3. Complete Pipeline ([ex-build/](ex-build/))

**Scripts:** 4 scripts demonstrating genrules + macros in a real workflow

**Build:**
```bash
bazel build //b/ex-build:all_outputs
```

**Pipeline:**
```
config.json
  ↓ [genrule: format_json.sh]
formatted_config.json (4-space indent)
  ↓ [genrule: validate_json.sh]
validation.txt
  ↓
config_dir
  ↓ [macro: bundle_configs]
prod_bundle.tar.gz (env=production)
dev_bundle.tar.gz (env=development)
  ↓ [macro: bundle_info]
{env}_bundle_info.txt (metadata)
```

**View:**
```bash
# Formatted JSON
cat bazel-bin/b/ex-build/formatted_config.json

# Production bundle info
cat bazel-bin/b/ex-build/prod_bundle_info.txt

# Extract bundle contents
tar xzf bazel-bin/b/ex-build/prod_bundle.tar.gz -O ./manifest.txt
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

See [COOL.md](COOL.md) for why this approach scales.
