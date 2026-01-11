# Agents

Python agents using the Claude SDK with MCP tools.

## Hello Agent

A simple agent demonstrating Claude SDK integration with MCP tools.

```bash
# Build and test
bazel build //agents/hello/...
bazel test //agents/hello/...

# Run the agent
bazel run //agents/hello:hello_py
```

The agent uses MCP tools from `//servers/hello` for:
- `get_time` - Current date/time
- `get_disk_usage` - Disk usage statistics
- `get_user_info` - Current user info
