"""MCP tool that returns the current time."""

from datetime import datetime, timezone
from typing import Any

from claude_agent_sdk import tool


@tool("get_time", "Get the current date and time in ISO format with timezone", {})
async def get_time_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return the current time in ISO format."""
    now = datetime.now(timezone.utc)
    local_now = datetime.now()

    return {
        "content": [
            {
                "type": "text",
                "text": (
                    f"Current time:\n"
                    f"  UTC: {now.isoformat()}\n"
                    f"  Local: {local_now.isoformat()}\n"
                    f"  Unix timestamp: {now.timestamp()}"
                ),
            }
        ]
    }
