# Example: Genrules with lib.sh

This demonstrates using bash scripts with `lib.sh` in direct genrule invocations.

## Structure

```
ex-genrule/
├── BUILD.bazel
└── scripts/
    ├── uppercase.sh    # Converts input to uppercase
    └── word_count.sh   # Counts words in input
```

Scripts are organized in `scripts/` subdirectory. Both use the `lib.sh` pattern:

```bash
function main {
    local input="${in[input]}"  # Named argument from key=value
    local out="${shome}/${out}" # Output file (first positional arg)
    # ... logic ...
}
source b/lib/lib.sh
```

## Genrules

Each genrule:

1. Lists the script and `//b/lib:lib_sh` as tools
2. Passes input using `input=$(location :target)` syntax
3. lib.sh parses `input=/path/to/file` into `in[input]`

## Try It

```bash
# Build individual outputs
bazel build //b/ex-genrule:uppercase_output
bazel build //b/ex-genrule:word_count_output

# Build chained pipeline
bazel build //b/ex-genrule:chained_output

# View outputs
cat bazel-bin/b/ex-genrule/uppercase.txt
cat bazel-bin/b/ex-genrule/word_count.txt
```

## Key Pattern

Genrule cmd syntax:

```python
cmd = "$(location :script_sh) key1=$(location :input1) key2=value2 $@"
```

The script receives:

- `in[key1]` = "/path/to/input1"
- `in[key2]` = "value2"
- `out` = output file path from `$@`
