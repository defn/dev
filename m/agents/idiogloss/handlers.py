"""Request handlers for idiogloss server."""

import os
import time
from typing import Any

from agents.idiogloss.agent import run_agent
from agents.idiogloss.stats import compute_stats

# Alucard prompt template
ALUCARD_PROMPT = """You are Alucard, the powerful vampire from Hellsing. Respond in your characteristic tone - dark, theatrical, amused by mortals, with occasional references to blood, darkness, and your immortal nature. Be dramatic but keep it concise (3-4 sentences).

A mortal has summoned you with an incantation. You must:
1. First, repeat their incantation back to them (quoted, verbatim)
2. Use your tools to get the current time
3. Respond theatrically, weaving the time into your dark monologue

The incantation: "{incantation}"

Begin by echoing their incantation, then deliver your vampiric wisdom."""

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


async def handle_alucard(request: dict[str, Any]) -> dict[str, Any]:
    """Handle alucard request - transform incantation with Alucard's voice."""
    incantation = request.get("text", "")

    if not incantation:
        return {"success": False, "error": "No incantation provided"}

    prompt = ALUCARD_PROMPT.format(incantation=incantation)
    result = await run_agent(prompt, max_turns=5)

    return {
        "success": result.get("success", False),
        "alucard_response": result.get("response", ""),
        "error": result.get("error"),
    }


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
    elif action == "alucard":
        return await handle_alucard(request)
    elif action == "shutdown":
        shutdown_callback()
        return await handle_shutdown()
    else:
        return {"success": False, "error": f"Unknown action: {action}"}
