# MCP Tools

Reusable tool implementations for MCP (Model Context Protocol) servers.

## Available Tools

| Tool | Module | Description |
|------|--------|-------------|
| `get_time` | `tools.time` | Current date/time in multiple formats |
| `get_disk_usage` | `tools.disk` | Filesystem space statistics |
| `get_user_info` | `tools.user` | Current user/group information |

## Usage

Tools are registered with MCP servers via the `@tool` decorator:

```python
from tools.time import get_time_tool
from tools.disk import get_disk_tool
from tools.user import get_user_tool

# Use with create_sdk_mcp_server
from claude_agent_sdk import create_sdk_mcp_server

server = create_sdk_mcp_server(
    name="my_server",
    version="1.0.0",
    tools=[get_time_tool, get_disk_tool, get_user_tool],
)
```

## Tool Response Format

All tools return MCP-compatible responses:

```python
{"content": [{"type": "text", "text": "<json-data>"}]}
```

For errors:

```python
{"content": [{"type": "text", "text": "<error-json>"}], "is_error": True}
```

## Adding New Tools

1. Create a new directory: `tools/mytool/`
2. Implement `tool.py` with the `@tool` decorator:

```python
from claude_agent_sdk import tool

@tool("my_tool_name", "Description for Claude", {"param": str})
async def my_tool(args: dict) -> dict:
    result = {"data": "..."}
    return {"content": [{"type": "text", "text": json.dumps(result)}]}
```

3. Export from `__init__.py`
4. Add to a server's tool list

## File Structure

```
tools/
├── __init__.py
├── README.md
├── time/
│   ├── __init__.py
│   ├── tool.py          # get_time_tool
│   └── tool_test.py
├── disk/
│   ├── __init__.py
│   ├── tool.py          # get_disk_tool
│   └── tool_test.py
└── user/
    ├── __init__.py
    ├── tool.py          # get_user_tool
    └── tool_test.py
```
