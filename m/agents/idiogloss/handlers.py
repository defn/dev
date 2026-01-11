"""Request handlers for idiogloss server."""

import os
import time
from typing import Any

from agents.idiogloss.agent import run_agent
from agents.idiogloss.stats import compute_stats

# Server start time (set when module is loaded)
SERVER_START_TIME = time.time()
SERVER_PID = os.getpid()


async def handle_ping() -> dict[str, Any]:
    """Handle ping request."""
    return {
        "success": True,
        "pong": True,
        "server_start_time": SERVER_START_TIME,
        "server_pid": SERVER_PID,
    }


async def handle_stats(request: dict[str, Any]) -> dict[str, Any]:
    """Handle stats request."""
    content = request.get("content", "")
    file_name = request.get("file_name", "unknown")
    stats = compute_stats(content)
    return {
        "success": True,
        "file_name": file_name,
        "stats": stats,
    }


async def handle_query(request: dict[str, Any]) -> dict[str, Any]:
    """Handle query request."""
    prompt = request.get("prompt", "")
    max_turns = request.get("max_turns", 5)

    if not prompt:
        return {"success": False, "error": "No prompt provided"}

    result = await run_agent(prompt, max_turns)
    return result


async def handle_shutdown() -> dict[str, Any]:
    """Handle shutdown request."""
    return {"success": True, "message": "Shutting down"}


async def dispatch_request(
    request: dict[str, Any],
    shutdown_callback: callable,
) -> dict[str, Any]:
    """Dispatch request to appropriate handler."""
    action = request.get("action", "query")

    if action == "ping":
        return await handle_ping()
    elif action == "stats":
        return await handle_stats(request)
    elif action == "query":
        return await handle_query(request)
    elif action == "shutdown":
        shutdown_callback()
        return await handle_shutdown()
    else:
        return {"success": False, "error": f"Unknown action: {action}"}
