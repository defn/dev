"""Time Tool - Current Date/Time for MCP.

Returns current time in multiple formats for maximum utility.

## Response Format

    {
        "utc": "2024-01-15T10:30:00+00:00",  # ISO 8601 UTC
        "local": "2024-01-15T05:30:00",       # ISO 8601 local (no TZ)
        "timestamp": 1705315800.123           # Unix epoch (float)
    }

## Why Multiple Formats?

- `utc` - Unambiguous, good for logging and comparison
- `local` - Human-readable for the user's timezone
- `timestamp` - Easy arithmetic, database storage

## MCP Tool Decorator

The `@tool` decorator from claude_agent_sdk registers this function:

    @tool("get_time", "Get current date and time as JSON", {})

Arguments:
1. Tool name (becomes `mcp__{server}__get_time`)
2. Description shown to Claude
3. Parameter schema (empty dict = no parameters)

## Return Format

MCP tools return a dict with "content" array:

    {"content": [{"type": "text", "text": "..."}]}

The text is JSON that Claude will parse and interpret.
"""

import json
from datetime import datetime, timezone
from typing import Any

from claude_agent_sdk import tool


@tool("get_time", "Get the current date and time as JSON", {})
async def get_time_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return the current time as JSON."""
    now = datetime.now(timezone.utc)
    local_now = datetime.now()

    data = {
        "utc": now.isoformat(),
        "local": local_now.isoformat(),
        "timestamp": now.timestamp(),
    }

    return {"content": [{"type": "text", "text": json.dumps(data)}]}
