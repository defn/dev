# Hello - Bazel Go + Python + MCP Example

Demonstrates Go and Python packages with Bazel, plus MCP (Model Context Protocol) tools.

## Build and Test

```bash
bazel build //hello/...
bazel test //hello/...
```

## Run Programs

```bash
# Go hello
bazel run //hello

# Python hello
bazel run //hello:hello_py

# Python hello with MCP demo
bazel run //hello:hello_py -- --mcp-demo
```

## MCP Server

The `hello_mcp` binary runs a standalone MCP server with three tools:
- `get_time` - Current date/time in ISO format
- `get_disk_usage` - Disk usage statistics
- `get_user_info` - Current user and group info

### Configure in Claude CLI

Create a mise task in `~/.mise/tasks/mcp`:

```bash
#!/bin/bash
#MISE description="Run MCP server for Claude CLI"

cd /home/ubuntu/m
exec bazel run --noshow_progress //hello:hello_mcp
```

Then configure Claude:

```bash
# Remove if already configured
claude mcp remove hello

# Add the MCP server
claude mcp add hello -- mise run mcp

# Verify connection
claude mcp list
```

### Test MCP Server Manually

Initialize and list tools:

```bash
bazel run --noshow_progress //hello:hello_mcp <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
EOF
```

Call `get_time`:

```bash
bazel run --noshow_progress //hello:hello_mcp <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
EOF
```

Call `get_disk_usage`:

```bash
bazel run --noshow_progress //hello:hello_mcp <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
EOF
```

Call `get_user_info`:

```bash
bazel run --noshow_progress //hello:hello_mcp <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```

Call all three tools:

```bash
bazel run --noshow_progress //hello:hello_mcp <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```
