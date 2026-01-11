"""Disk Usage Tool - Filesystem Statistics for MCP.

Returns disk space information for a given path.

## Response Format

    {
        "path": "/",
        "total_bytes": 107374182400,
        "used_bytes": 53687091200,
        "free_bytes": 53687091200,
        "percent_used": 50.0
    }

## Parameters

This tool accepts an optional `path` parameter:

    @tool("get_disk_usage", "...", {"path": str})

- If omitted, defaults to "/" (root filesystem)
- Can query any mounted filesystem: "/home", "/tmp", etc.

## Error Handling

If the path doesn't exist or isn't accessible:

    {"error": "No such file or directory: '/invalid'"}

The response includes `is_error: True` to signal failure to Claude.

## Implementation

Uses `shutil.disk_usage()` which is cross-platform:
- Linux: statfs() syscall
- macOS: statfs() syscall
- Windows: GetDiskFreeSpaceEx()
"""

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
