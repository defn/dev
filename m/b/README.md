# Bash Scripts in Bazel

A beginner-friendly system for integrating bash scripts into Bazel builds, with examples progressing from simple to expert-level patterns.

## What Is This?

This is a practical approach to using **bash scripts as Bazel build targets**. You write normal bash scripts, and Bazel handles:

- **Caching** (run once, reuse results)
- **Dependency tracking** (rebuild only what changed)
- **Parallel execution** (run independent tasks simultaneously)

No Starlark expertise required to get started.

---

## Quick Start (5 minutes)

Build and run all examples:

```bash
cd m
bazel build //b/... # Builds all 23 example targets
```

View some outputs:

```bash
# Simple text transformation
cat bazel-bin/b/ex-genrule/uppercase.txt
# Output: HELLO WORLD FROM BAZEL GENRULE EXAMPLE

# Config bundle for deployment
tar tzf bazel-bin/b/ex-build/production_config_bundle.tar.gz
# Output: ./prod-configs/app.conf, database.conf, cache.conf
```

That's it! You just ran bash scripts through Bazel.

---

## Why Use Bazel for Bash Scripts?

**Problem:** Traditional bash scripts rebuild everything every time, even if nothing changed.

```bash
# old-way.sh - Always runs all steps
compile_code
run_tests
build_docker_image  # Even if code didn't change!
```

**Solution:** Bazel tracks what changed and only rebuilds affected steps.

```python
# BUILD.bazel - Bazel knows dependencies
genrule(name = "compile", ...)      # Only runs if source changed
genrule(name = "test", srcs = [":compile"], ...)  # Only if compile ran
genrule(name = "docker", srcs = [":test"], ...)   # Only if test ran
```

---

## Understanding Bazel (Beginner Level)

### What is Bazel?

Bazel is a **build system** that tracks dependencies between files and only rebuilds what changed.

**Key Concepts:**

1. **Workspace** - Your project root (where `WORKSPACE` file lives)
2. **Package** - A directory with a `BUILD.bazel` file
3. **Target** - Something to build (a file, a command, etc.)
4. **Label** - How you reference targets: `//path/to/package:target_name`

### Example: Simple Bazel Target

```python
# b/ex-genrule/BUILD.bazel
genrule(
    name = "sample_input",
    outs = ["sample.txt"],
    cmd = "echo 'hello world' > $@",
)
```

This creates a target `//b/ex-genrule:sample_input` that produces `sample.txt`.

Build it:

```bash
bazel build //b/ex-genrule:sample_input
cat bazel-bin/b/ex-genrule/sample.txt  # hello world
```

**Caching in action:**

```bash
bazel build //b/ex-genrule:sample_input  # First time: runs command
bazel build //b/ex-genrule:sample_input  # Second time: instant (cached!)
```

---

## The lib.sh Pattern (Core Concept)

The challenge: Bazel passes files to scripts, but how do you handle arguments cleanly?

### Without lib.sh (confusing positional args)

```bash
# ugly-script.sh
INPUT_FILE=$1
OUTPUT_FILE=$2
FORMAT=$3  # Wait, which position is this?
```

### With lib.sh (named arguments!)

```bash
# clean-script.sh
function main {
    local input="${in[input]}"    # Named: input=/path/to/file
    local format="${in[format]}"  # Named: format=json
    local out="${shome}/${out}"   # Auto-parsed output

    # Your logic here
}

source b/lib/lib.sh  # Handles parsing, calls main()
```

**Usage in Bazel:**

```python
genrule(
    name = "process",
    tools = ["//b/lib:lib_sh", ":clean_script_sh"],
    cmd = "$(location :clean_script_sh) input=$(location :data) format=json $@",
)
```

Much more readable!

---

## Three Examples (Learning Path)

### Level 1: Direct Genrules ([ex-genrule/](ex-genrule/))

**What:** Run bash scripts directly from BUILD files
**When:** One-off transformations, learning Bazel basics

**Structure:**

```
ex-genrule/
├── BUILD.bazel
└── scripts/
    ├── uppercase.sh    # Converts text to uppercase
    └── word_count.sh   # Counts words
```

**Try it:**

```bash
# Build outputs
bazel build //b/ex-genrule:uppercase_output
bazel build //b/ex-genrule:word_count_output

# Chain them together
bazel build //b/ex-genrule:chained_output  # uppercase → word_count

# View results
cat bazel-bin/b/ex-genrule/uppercase.txt
```

**How it works:**

```python
# BUILD.bazel
genrule(
    name = "uppercase_output",
    tools = [":uppercase_sh", "//b/lib:lib_sh"],
    srcs = [":sample_input"],
    outs = ["uppercase.txt"],
    cmd = "$(location :uppercase_sh) input=$(location :sample_input) $@",
)
```

See [ex-genrule/README.md](ex-genrule/README.md) for details.

---

### Level 2: Reusable Macros ([ex-macros/](ex-macros/))

**What:** Wrap scripts in Starlark functions for reuse
**When:** You call the same operation multiple times

**Structure:**

```
ex-macros/
├── BUILD.bazel
├── macros.bzl          # Reusable functions
└── scripts/
    ├── create_archive.sh
    └── list_archive.sh
```

**Try it:**

```bash
# Build archives
bazel build //b/ex-macros:my_archive
bazel build //b/ex-macros:archive_metadata

# Inspect
tar tzf bazel-bin/b/ex-macros/my_archive.tar.gz
cat bazel-bin/b/ex-macros/archive_metadata.txt
```

**How it works:**

Instead of writing genrules every time:

```python
# Without macro (repetitive)
genrule(name = "archive1", tools = [...], cmd = "...")
genrule(name = "archive2", tools = [...], cmd = "...")
genrule(name = "archive3", tools = [...], cmd = "...")
```

Use a macro:

```python
# With macro (DRY - Don't Repeat Yourself)
load("//b/ex-macros:macros.bzl", "archive_directory")

archive_directory(name = "archive1", dir = ":files1")
archive_directory(name = "archive2", dir = ":files2")
archive_directory(name = "archive3", dir = ":files3")
```

The macro handles the genrule boilerplate.

See [ex-macros/README.md](ex-macros/README.md) for details.

---

### Level 3: Cross-Package Composition ([ex-build/](ex-build/))

**What:** Import and combine tools from other packages
**When:** Building real applications with multiple steps

**Structure:**

```
ex-build/
├── BUILD.bazel         # No scripts! Pure composition
└── README.md
```

**Try it:**

```bash
# Build complete pipeline
bazel build //b/ex-build:all_outputs

# View results
cat bazel-bin/b/ex-build/normalized/app.conf  # Uppercase text
cat bazel-bin/b/ex-build/reports/app_size.txt # Word count
tar tzf bazel-bin/b/ex-build/production_config_bundle.tar.gz  # Archive
```

**Pipeline visualization:**

```
Raw Configs
  ↓ import uppercase.sh from //b/ex-genrule
Normalized Configs (UPPERCASE)
  ↓ import word_count.sh from //b/ex-genrule
Size Reports
  ↓ import archive_directory() from //b/ex-macros
Production & Staging Bundles
  ↓ import archive_info() from //b/ex-macros
Bundle Metadata
```

**How it works:**

Import tools from other packages:

```python
# ex-build/BUILD.bazel
load("//b/ex-macros:macros.bzl", "archive_directory")  # Import macro

genrule(
    name = "normalized_app",
    tools = ["//b/ex-genrule:uppercase_sh"],  # Import script
    cmd = "$(location //b/ex-genrule:uppercase_sh) input=... $@",
)

archive_directory(
    name = "prod_bundle",
    dir = ":normalized_configs",
)
```

**Key insight:** Fix a bug in `uppercase.sh` once, all clients benefit!

See [ex-build/README.md](ex-build/README.md) for details.

---

## How It Works (Intermediate Level)

### The lib.sh Magic

When you write:

```bash
function main {
    local input="${in[input]}"
}
source b/lib/lib.sh
```

Here's what happens:

1. **lib.sh parses arguments**

   - `key=value` pairs → `in[]` associative array
   - First positional arg → `$out` variable
   - Remaining args → `args[]` array

2. **lib.sh calls your `main()` function**
   - Your code runs with parsed arguments
   - No manual parsing needed!

**Full lib.sh flow:**

```bash
# Input:  script.sh input=/data/file.txt format=json output.tar.gz extra1 extra2
# Result:
#   in[input]  = "/data/file.txt"
#   in[format] = "json"
#   out        = "output.tar.gz"
#   args       = ("extra1" "extra2")
```

### Bazel Integration

In BUILD.bazel:

```python
genrule(
    name = "transform",
    tools = [
        ":script_sh",           # Your bash script
        "//b/lib:lib_sh",       # The lib.sh parser
    ],
    srcs = [":input_data"],
    outs = ["output.tar.gz"],
    cmd = "$(location :script_sh) input=$(location :input_data) format=json $@",
    #      └─ script             └─ becomes in[input]       └─ becomes in[format]  └─ becomes $out
)
```

Bazel:

1. Makes your script and lib.sh available as `$(location ...)`
2. Substitutes `$(location :input_data)` with actual path
3. Passes `$@` (the output file path)
4. Runs the command in a sandbox

### Caching Mechanism

Bazel hashes inputs:

```
hash(script.sh) + hash(input_data) + hash(format=json) = ABC123
```

**First build:**

- Hash = ABC123
- No cached result
- Runs script
- Saves output with hash ABC123

**Second build:**

- Hash = ABC123 (nothing changed)
- Found cached result
- Returns cached output instantly

**After editing input_data:**

- Hash = XYZ789 (input changed!)
- No cached result for XYZ789
- Runs script again

---

## Advanced Patterns (Expert Level)

### Pattern 1: Multiple File Handling

Bazel passes files individually, not directories:

```python
genrule(
    name = "process_many",
    srcs = [":config_dir"],  # Expands to multiple files
    outs = ["result.tar.gz"],
    cmd = "$(location :script) $@ $(locations :config_dir)",
    #                               └─ Note: locations (plural)
)
```

Your script receives all files:

```bash
function main {
    local out="${shome}/${out}"

    # args[] contains all config files
    for config in "${args[@]}"; do
        process "${config}"
    done
}
```

### Pattern 2: Conditional Arguments

Default values and optional args:

```bash
function main {
    local format="${in[format]:-json}"   # Default to json
    local verbose="${in[verbose]}"        # Optional (empty if unset)

    if [[ -n "${verbose}" ]]; then
        echo "Processing in ${format} format..."
    fi
}
```

Usage:

```python
cmd = "$(location :script) format=yaml verbose=true $@"  # All set
cmd = "$(location :script) $@"                           # Uses defaults
```

### Pattern 3: Tool Chains

Compose multiple tools:

```python
# Step 1: Generate
genrule(name = "gen", tools = [":generator"], ...)

# Step 2: Validate (depends on gen)
genrule(name = "validate", srcs = [":gen"], tools = [":validator"], ...)

# Step 3: Package (depends on validate)
genrule(name = "package", srcs = [":validate"], tools = [":packager"], ...)
```

Bazel runs them in order, caching each step.

### Pattern 4: Cross-Repository References

Reference tools from external repos:

```python
genrule(
    name = "format",
    tools = ["@external_repo//path/to:formatter"],
    cmd = "$(location @external_repo//path/to:formatter) $@",
)
```

### Pattern 5: Platform-Specific Scripts

```python
genrule(
    name = "build",
    cmd = select({
        "@platforms//os:linux": "$(location :linux_build_sh) $@",
        "@platforms//os:macos": "$(location :mac_build_sh) $@",
    }),
)
```

---

## Directory Reference

### What's in `m/b/`

```
b/
├── lib/              # Core library
│   ├── BUILD.bazel
│   ├── lib.sh        # Argument parsing for bash scripts
│   └── README.md
│
├── out/              # Output utilities
│   ├── BUILD.bazel
│   ├── out.bzl       # Copy build outputs back to source tree
│   └── README.md
│
├── ex-genrule/       # Example: Direct genrule usage
│   ├── BUILD.bazel
│   ├── README.md
│   └── scripts/
│       ├── uppercase.sh
│       └── word_count.sh
│
├── ex-macros/        # Example: Reusable macros
│   ├── BUILD.bazel
│   ├── macros.bzl
│   ├── README.md
│   └── scripts/
│       ├── create_archive.sh
│       └── list_archive.sh
│
├── ex-build/         # Example: Cross-package composition
│   ├── BUILD.bazel
│   └── README.md
│
└── README.md         # This file
```

### lib/ - Core Library

**Purpose:** Provides `lib.sh` for argument parsing in bash scripts.

**Key file:** [lib/lib.sh](lib/lib.sh)

**Usage:**

```bash
function main {
    local var="${in[key]}"
    local out="${shome}/${out}"
}
source b/lib/lib.sh
```

**Exports:**

- `//b/lib:lib_sh` - Filegroup for use in Bazel rules

### out/ - Output Utilities

**Purpose:** Copy Bazel outputs back to source tree (for code generation workflows).

**Key file:** [out/out.bzl](out/out.bzl)

**Usage:**

```python
load("//b/out:out.bzl", "copy_files")

copy_files(
    name = "copy_generated",
    gen = {"generated.go": "//pkg:generator"},
    dir = ".",
)
```

Then run: `bazel run //pkg:copy_generated__copy`

This copies `bazel-bin/pkg/generated.go` → `pkg/generated.go` in your source tree.

---

## Common Patterns

### Key-Value Arguments

```python
cmd = "$(location :script) format=json verbose=true $@"
```

```bash
local format="${in[format]}"   # = "json"
local verbose="${in[verbose]}" # = "true"
```

### File Arguments

```python
cmd = "$(location :script) input=$(location :data) $@"
```

```bash
local input="${in[input]}"  # = "/path/to/data"
```

### Multiple Files

```python
cmd = "$(location :script) $@ $(locations :files)"
```

```bash
for file in "${args[@]}"; do
    echo "Processing ${file}"
done
```

### Optional Arguments with Defaults

```bash
local format="${in[format]:-json}"      # Default: json
local timeout="${in[timeout]:-30}"      # Default: 30
```

---

## Package Structure Best Practices

### When to Use Subdirectories

**Small packages (1-2 scripts):** Top-level is fine

```
my-tool/
├── BUILD.bazel
└── script.sh
```

**Medium packages (3-5 scripts):** Use `scripts/`

```
my-tool/
├── BUILD.bazel
└── scripts/
    ├── build.sh
    ├── test.sh
    └── deploy.sh
```

**Large packages (6+ scripts):** Nested subdirectories

```
my-tool/
├── BUILD.bazel
├── macros.bzl
└── scripts/
    ├── build/
    │   ├── docker.sh
    │   └── helm.sh
    └── test/
        ├── unit.sh
        └── integration.sh
```

### Referencing Scripts

In BUILD.bazel:

```python
filegroup(
    name = "script_sh",
    srcs = ["scripts/build.sh"],  # Relative path
    visibility = ["//visibility:public"],
)
```

From other packages:

```python
genrule(
    tools = ["//b/my-tool:script_sh"],  # Label reference (unchanged)
)
```

The internal structure (`scripts/`) is hidden from consumers.

---

## Common Issues & Solutions

### Issue: "Permission denied" when running script

**Cause:** Script not executable

**Fix:**

```bash
chmod +x b/my-tool/scripts/*.sh
git add b/my-tool/scripts/*.sh
```

### Issue: "File not found" for lib.sh

**Cause:** Wrong path in `source` statement

**Fix:** Use workspace-relative path:

```bash
source b/lib/lib.sh  # ✓ Correct
source ./lib/lib.sh  # ✗ Wrong
source /home/user/m/b/lib/lib.sh  # ✗ Wrong (absolute)
```

### Issue: Genrule always rebuilds

**Cause:** Non-deterministic output (timestamps, random values, etc.)

**Fix:** Make output deterministic:

```bash
# ✗ Bad: timestamp changes every run
echo "Built at $(date)" > output.txt

# ✓ Good: stable output
echo "Version 1.0.0" > output.txt
```

### Issue: Can't pass directory to script

**Cause:** Bazel doesn't support directory arguments

**Fix:** Pass individual files:

```python
# ✗ Wrong
srcs = [":my_directory"]
cmd = "$(location :script) dir=$(location :my_directory) $@"

# ✓ Correct
srcs = [":my_files"]  # Target outputs multiple files
cmd = "$(location :script) $@ $(locations :my_files)"
```

---

## Next Steps

1. **Start simple:** Copy [ex-genrule/](ex-genrule/) pattern for your first script
2. **Learn macros:** When you repeat a genrule 3+ times, make a macro
3. **Compose:** Import tools from multiple packages like [ex-build/](ex-build/)
4. **Scale:** Use `scripts/` subdirectories as your package grows

## Learning Resources

- **Bazel Docs:** https://bazel.build/concepts/build-ref
- **Genrule Reference:** https://bazel.build/reference/be/general#genrule
- **Starlark Language:** https://bazel.build/rules/language

---

## Philosophy

This system prioritizes:

1. **Accessibility** - Bash knowledge >> Starlark knowledge
2. **Composability** - Small tools that combine well
3. **Caching** - Build once, reuse everywhere
4. **Incremental** - Only rebuild what changed
5. **Debuggable** - It's just bash, you can run it manually

Bazel gives you the build system, bash gives you the flexibility.
