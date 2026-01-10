"""MCP tool that returns disk utilization information."""

import json
import shutil
from typing import Any

from claude_agent_sdk import tool


@tool(
    "get_disk_usage",
    "Get disk usage statistics as JSON for a given path (default: root filesystem)",
    {"path": str},
)
async def get_disk_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return disk usage statistics as JSON."""
    path = args.get("path", "/")

    try:
        usage = shutil.disk_usage(path)
        data = {
            "path": path,
            "total_bytes": usage.total,
            "used_bytes": usage.used,
            "free_bytes": usage.free,
            "percent_used": round((usage.used / usage.total) * 100, 1),
        }
        return {"content": [{"type": "text", "text": json.dumps(data)}]}
    except OSError as e:
        return {
            "content": [{"type": "text", "text": json.dumps({"error": str(e)})}],
            "is_error": True,
        }
