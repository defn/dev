"""MCP tool that returns the current time."""

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
