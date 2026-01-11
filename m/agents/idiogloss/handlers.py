"""Request Handlers for Idiogloss Server.

This module dispatches incoming requests to appropriate handlers.

## Supported Actions

| Action     | Handler           | Description                          |
|------------|-------------------|--------------------------------------|
| ping       | handle_ping       | Health check, returns uptime/PID     |
| stats      | handle_stats      | Compute line/word/char counts        |
| query      | handle_query      | Run agent with arbitrary prompt      |
| alucard    | handle_alucard    | Theatrical vampire response mode     |
| shutdown   | handle_shutdown   | Graceful server stop                 |

## Alucard Mode

The "alucard" action is a themed wrapper around the agent. It:

1. Wraps user text in a vampire-themed prompt
2. Instructs Claude to respond as Alucard from Hellsing
3. Uses MCP tools (get_time, etc.) for context
4. Streams progress updates back to client

This demonstrates agent customization via prompt engineering.

## Progress Updates

Long-running handlers (alucard, query) accept an `on_update` callback.
This enables streaming partial results back to the client:

    async def send_update(update: dict) -> None:
        await on_update({"type": "progress", "update": update})

The client receives these as intermediate responses before the final one.

## Server Metadata

SERVER_START_TIME and SERVER_PID are captured at module load for
uptime tracking in ping responses.
"""

import os
import time
from typing import Any, Awaitable, Callable

from agents.idiogloss.agent import run_agent
from agents.idiogloss.stats import compute_stats

# Type for async write callback
WriteCallback = Callable[[dict[str, Any]], Awaitable[None]] | None

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


async def handle_alucard(
    request: dict[str, Any],
    on_update: WriteCallback = None,
) -> dict[str, Any]:
    """Handle alucard request - transform incantation with Alucard's voice."""
    incantation = request.get("text", "")

    if not incantation:
        return {"success": False, "error": "No incantation provided"}

    prompt = ALUCARD_PROMPT.format(incantation=incantation)

    # Create update callback to send progress
    async def send_update(update: dict[str, Any]) -> None:
        if on_update:
            await on_update({"type": "progress", "update": update})

    result = await run_agent(prompt, max_turns=5, on_update=send_update)

    response_text = result.get("response", "")
    print(f"[handler] result.response length: {len(response_text)}", flush=True)
    print(f"[handler] result.success: {result.get('success')}", flush=True)
    print(f"[handler] result.error: {result.get('error')}", flush=True)

    return {
        "success": result.get("success", False),
        "alucard_response": response_text,
        "error": result.get("error"),
    }


async def handle_shutdown() -> dict[str, Any]:
    """Handle shutdown request."""
    return {"success": True, "message": "Shutting down"}


async def dispatch_request(
    request: dict[str, Any],
    shutdown_callback: callable,
    on_update: WriteCallback = None,
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
        return await handle_alucard(request, on_update=on_update)
    elif action == "shutdown":
        shutdown_callback()
        return await handle_shutdown()
    else:
        return {"success": False, "error": f"Unknown action: {action}"}
