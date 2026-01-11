# MCP Servers

MCP (Model Context Protocol) servers in Go and Python.

## Hello Server

Both Python and Go MCP servers provide the same three tools:

- `get_time` - Current date/time as JSON
- `get_disk_usage` - Disk usage statistics as JSON
- `get_user_info` - Current user and group info as JSON

| Feature | Python                         | Go                                       |
| ------- | ------------------------------ | ---------------------------------------- |
| Target  | `//servers/hello:server_py` | `//servers/hello:server_go`         |
| SDK     | `mcp` (PyPI)                   | `github.com/modelcontextprotocol/go-sdk` |

### Build and Test

```bash
bazel build //servers/hello/...
bazel test //servers/hello/...
```

### Configure in Claude CLI

Create mise tasks in `~/.mise/tasks/`:

**Python** (`~/.mise/tasks/mcp-hello-py`):

```bash
#!/bin/bash
#MISE description="Run Python MCP server for Claude CLI"

cd /home/ubuntu/m
exec bazel run --noshow_progress //servers/hello:server_py
```

**Go** (`~/.mise/tasks/mcp-hello-go`):

```bash
#!/bin/bash
#MISE description="Run Go MCP server for Claude CLI"

cd /home/ubuntu/m
exec bazel run --noshow_progress //servers/hello:server_go
```

Then configure Claude (choose one):

```bash
# Python MCP server
claude mcp remove hello 2>/dev/null; claude mcp add hello -- mise run mcp-hello-py

# Go MCP server
claude mcp remove hello 2>/dev/null; claude mcp add hello -- mise run mcp-hello-go

# Verify
claude mcp list
```

### Test MCP Servers Manually

Build first for direct execution:

```bash
bazel build //servers/hello:server_py //servers/hello:server_go
```

#### Initialize and List Tools

**Python:**

```bash
bazel-bin/servers/hello/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'; sleep 0.2 ) | bazel-bin/servers/hello/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_time`

**Python:**

```bash
bazel-bin/servers/hello/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}'; sleep 0.2 ) | bazel-bin/servers/hello/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_disk_usage`

**Python:**

```bash
bazel-bin/servers/hello/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}'; sleep 0.2 ) | bazel-bin/servers/hello/server_go_/server_go 2>/dev/null | jq
```

#### Call `get_user_info`

**Python:**

```bash
bazel-bin/servers/hello/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}'; sleep 0.2 ) | bazel-bin/servers/hello/server_go_/server_go 2>/dev/null | jq
```

#### Call All Three Tools

**Python:**

```bash
bazel-bin/servers/hello/server_py <<'EOF' 2>/dev/null | jq
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}
{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}
EOF
```

**Go:**

```bash
( echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_time","arguments":{}}}'; echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_disk_usage","arguments":{"path":"/"}}}'; echo '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"get_user_info","arguments":{}}}'; sleep 0.2 ) | bazel-bin/servers/hello/server_go_/server_go 2>/dev/null | jq
```
