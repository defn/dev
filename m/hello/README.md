# Hello - Bazel Go + Python + MCP Example

Demonstrates Go and Python packages with Bazel, plus MCP (Model Context Protocol) tools.

## Build and Test

```bash
bazel build //hello/...
bazel test //hello/...
```

## Run Programs

```bash
# Go hello (simple greeter)
bazel run //hello:hello_go

# Python agent (Claude SDK with MCP tools)
bazel run //hello:hello_py
```

## MCP Servers

Both Python and Go MCP servers provide the same three tools:

- `get_time` - Current date/time as JSON
- `get_disk_usage` - Disk usage statistics as JSON
- `get_user_info` - Current user and group info as JSON

| Feature | Python                  | Go                                       |
| ------- | ----------------------- | ---------------------------------------- |
| Target  | `//hello/mcp:server_py` | `//hello/mcp:server_go`                  |
| SDK     | `mcp` (PyPI)            | `github.com/modelcontextprotocol/go-sdk` |

### Configure in Claude CLI

Create mise tasks in `~/.mise/tasks/`:

**Python** (`~/.mise/tasks/mcp-py`):

```bash
#!/bin/bash
#MISE description="Run Python MCP server for Claude CLI"

cd /home/ubuntu/m
exec bazel run --noshow_progress //hello/mcp:server_py
```

**Go** (`~/.mise/tasks/mcp-go`):

```bash
#!/bin/bash
#MISE description="Run Go MCP server for Claude CLI"

cd /home/ubuntu/m
exec bazel run --noshow_progress //hello/mcp:server_go
```

Then configure Claude (choose one):

```bash
# Python MCP server
claude mcp remove hello 2>/dev/null; claude mcp add hello -- mise run mcp-py

# Go MCP server
claude mcp remove hello 2>/dev/null; claude mcp add hello -- mise run mcp-go

# Verify
claude mcp list
```

### Test MCP Servers Manually

Build first for direct execution:

```bash
bazel build //hello/mcp:server_py //hello/mcp:server_go
```

#### Initialize and List Tools

**Python:**

```bash
bazel-bin/hello/mcp/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'; sleep 0.2 ) | bazel-bin/hello/mcp/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_time`

**Python:**

```bash
bazel-bin/hello/mcp/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}'; sleep 0.2 ) | bazel-bin/hello/mcp/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_disk_usage`

**Python:**

```bash
bazel-bin/hello/mcp/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}'; sleep 0.2 ) | bazel-bin/hello/mcp/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_user_info`

**Python:**

```bash
bazel-bin/hello/mcp/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}'; sleep 0.2 ) | bazel-bin/hello/mcp/server_go_/server_go 2>/dev/null | jq
```

#### Call All Three Tools

**Python:**

```bash
bazel-bin/hello/mcp/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}'; echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}'; echo '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}'; sleep 0.2 ) | bazel-bin/hello/mcp/server_go_/server_go 2>/dev/null | jq
```
