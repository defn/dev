# Idiogloss Agent

Backend agent for the idiogloss VS Code extension, using Claude Agent SDK with MCP tools.

## Quick Start

```bash
# Build
bazel build //agents/idiogloss/...

# Run server (for extension)
bazel run //agents/idiogloss:server_py

# Run interactive agent
bazel run //agents/idiogloss:agent_py

# Run with single prompt
bazel run //agents/idiogloss:agent_py -- "What time is it?"
```

## Server

The server communicates with the VS Code extension via Unix socket (`/tmp/idiogloss.sock`).

### Actions

| Action     | Description                             |
| ---------- | --------------------------------------- |
| `ping`     | Health check, returns server uptime/PID |
| `stats`    | Compute line/word/char counts           |
| `query`    | Run agent with arbitrary prompt         |
| `alucard`  | Theatrical vampire response (streaming) |
| `shutdown` | Stop the server                         |

### Logging

Logs are written to `/tmp/idiogloss-server.log` for debugging.

## MCP Tools

The agent has access to these tools via an in-process MCP server:

| Tool             | Description                         |
| ---------------- | ----------------------------------- |
| `get_time`       | Get current date/time in ISO format |
| `get_disk_usage` | Get disk usage statistics           |
| `get_user_info`  | Get current user/group info         |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Idiogloss Agent                          │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │ ClaudeSDKClient │───▶│ In-Process MCP Server           │ │
│  │                 │    │  - get_time                     │ │
│  │ (Claude API)    │◀───│  - get_disk_usage               │ │
│  │                 │    │  - get_user_info                │ │
│  └─────────────────┘    └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
         │
         │ Unix Socket (JSON)
         ▼
┌─────────────────────────────────────────────────────────────┐
│              VS Code Extension (idiogloss)                  │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │ Extension Host  │───▶│ Webview Panel                   │ │
│  │ (Node.js)       │◀───│ (Svelte)                        │ │
│  └─────────────────┘    └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## File Structure

```
agents/idiogloss/
├── server.py          # Unix socket server
├── agent.py           # Claude agent with MCP tools
├── handlers.py        # Request handlers (ping, stats, query)
├── stats.py           # Content statistics computation
├── logging_config.py  # File + stderr logging setup
└── BUILD.bazel        # Bazel build rules
```
