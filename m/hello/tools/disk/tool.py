"""MCP tool that returns disk utilization information."""

import shutil
from typing import Any

from claude_agent_sdk import tool


@tool(
    "get_disk_usage",
    "Get disk usage statistics for a given path (default: root filesystem)",
    {"path": str},
)
async def get_disk_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return disk usage statistics."""
    path = args.get("path", "/")

    try:
        usage = shutil.disk_usage(path)
        total_gb = usage.total / (1024**3)
        used_gb = usage.used / (1024**3)
        free_gb = usage.free / (1024**3)
        percent_used = (usage.used / usage.total) * 100

        return {
            "content": [
                {
                    "type": "text",
                    "text": (
                        f"Disk usage for '{path}':\n"
                        f"  Total: {total_gb:.2f} GB ({usage.total} bytes)\n"
                        f"  Used: {used_gb:.2f} GB ({usage.used} bytes)\n"
                        f"  Free: {free_gb:.2f} GB ({usage.free} bytes)\n"
                        f"  Usage: {percent_used:.1f}%"
                    ),
                }
            ]
        }
    except OSError as e:
        return {
            "content": [{"type": "text", "text": f"Error getting disk usage: {e}"}],
            "is_error": True,
        }
