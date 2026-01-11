# Hello - CUE Schema Validation Example

Demonstrates CUE language integration in Go for config validation.

## Build and Test

```bash
bazel build //hello/...
bazel test //hello/...
```

## Run

```bash
bazel run //hello:hello_go
```

## Structure

- `hello.cue` - CUE schema defining greeting config structure
- `greeting.go` - Go code that validates config against CUE schema
- `main.go` - CLI entry point
