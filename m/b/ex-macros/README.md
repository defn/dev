# Example: Macros with lib.sh

This demonstrates wrapping bash scripts in Starlark macros for reusability.

## Structure

```
ex-macros/
├── BUILD.bazel
├── macros.bzl
└── scripts/
    ├── create_archive.sh   # Creates tarball
    └── list_archive.sh     # Lists tarball contents
```

Scripts are in `scripts/` subdirectory, wrapped by `macros.bzl`.

## Macros

The `.bzl` file provides high-level macros:

```python
archive_directory(
    name = "my_archive",
    dir = ":source_files",
    prefix = "myproject",
)

archive_info(
    name = "metadata",
    archive = ":my_archive",
)
```

Macros hide the genrule boilerplate:

- Auto-add `//b/lib:lib_sh` to tools
- Format `cmd` with proper `$(location ...)` syntax
- Handle optional arguments with defaults

## Try It

```bash
# Build archive
bazel build //b/ex-macros:my_archive

# View archive contents
tar tzf bazel-bin/b/ex-macros/my_archive.tar.gz

# Build metadata
bazel build //b/ex-macros:archive_metadata

# View metadata
cat bazel-bin/b/ex-macros/archive_metadata.txt
```

## Benefits of Macros

1. **Reusability** - Call `archive_directory()` anywhere in the monorepo
2. **Consistency** - Same pattern for all archive operations
3. **Discoverability** - Users see `archive_directory()`, not raw genrule
4. **Maintainability** - Fix bugs in one place (the macro)
5. **Auto-generation** - Regular structure enables generating macros from manifests
