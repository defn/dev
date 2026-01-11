#!/usr/bin/env python3
"""Idiogloss agent using Claude Agent SDK with MCP tools.

This agent provides a backend for the idiogloss VS Code extension,
running an in-process MCP server with system information tools.
"""

import asyncio
import json
import sys
from typing import Any

from claude_agent_sdk import ClaudeAgentOptions, ClaudeSDKClient
from servers.hello.server import create_hello_server

# Type alias for update callback
UpdateCallback = Any  # Callable[[dict[str, Any]], Awaitable[None]] | None


async def run_agent(
    prompt: str,
    max_turns: int = 5,
    on_update: UpdateCallback = None,
) -> dict[str, Any]:
    """Run the idiogloss agent with a given prompt.

    Args:
        prompt: The user prompt to process.
        max_turns: Maximum number of agent turns.
        on_update: Optional async callback for streaming updates.
            Called with {"type": "tool_call", "name": "...", "input": {...}}
            or {"type": "text", "text": "..."} as the agent works.

    Returns:
        A dict with the agent response and metadata.
    """
    mcp_server = create_hello_server(name="idiogloss_tools", version="1.0.0")

    options = ClaudeAgentOptions(
        max_turns=max_turns,
        mcp_servers={"idiogloss": mcp_server},
        allowed_tools=[
            "mcp__idiogloss__get_time",
            "mcp__idiogloss__get_disk_usage",
            "mcp__idiogloss__get_user_info",
        ],
    )

    result = {
        "response": "",
        "tool_calls": [],
        "success": True,
        "error": None,
    }

    try:
        async with ClaudeSDKClient(options=options) as client:
            await client.query(prompt)
            async for msg in client.receive_response():
                msg_type = type(msg).__name__
                print(f"[agent] msg type: {msg_type}", flush=True)

                # Extract text from ResultMessage (final response)
                if hasattr(msg, "result") and msg.result:
                    print(
                        f"[agent] ResultMessage.result: {msg.result[:100]}...",
                        flush=True,
                    )
                    result["response"] = msg.result
                # Or from AssistantMessage content blocks
                elif hasattr(msg, "content"):
                    for block in msg.content:
                        block_type = type(block).__name__
                        if hasattr(block, "text"):
                            print(
                                f"[agent] {block_type} text: {block.text[:50]}...",
                                flush=True,
                            )
                            result["response"] += block.text
                            # Send text update
                            if on_update:
                                await on_update({"type": "text", "text": block.text})
                        elif hasattr(block, "name"):
                            # Tool use block
                            print(
                                f"[agent] {block_type} tool: {block.name}", flush=True
                            )
                            tool_call = {
                                "name": block.name,
                                "input": getattr(block, "input", {}),
                            }
                            result["tool_calls"].append(tool_call)
                            # Send tool call update
                            if on_update:
                                await on_update({"type": "tool_call", **tool_call})

            print(
                f"[agent] final response length: {len(result['response'])}", flush=True
            )
    except Exception as e:
        result["success"] = False
        result["error"] = str(e)
        print(f"[agent] error: {e}", flush=True)

    return result


async def interactive_mode():
    """Run the agent in interactive mode, reading prompts from stdin."""
    print("Idiogloss Agent Interactive Mode")
    print("Type your prompt and press Enter. Type 'quit' to exit.")
    print("-" * 50)

    while True:
        try:
            prompt = input("\n> ").strip()
            if prompt.lower() in ("quit", "exit", "q"):
                break
            if not prompt:
                continue

            print("\nProcessing...")
            result = await run_agent(prompt)

            if result["success"]:
                print(f"\nResponse:\n{result['response']}")
                if result["tool_calls"]:
                    print(f"\nTools used: {[t['name'] for t in result['tool_calls']]}")
            else:
                print(f"\nError: {result['error']}")

        except EOFError:
            break
        except KeyboardInterrupt:
            break

    print("\nGoodbye!")


async def json_mode():
    """Run the agent in JSON mode for programmatic use.

    Reads JSON from stdin: {"prompt": "...", "max_turns": 5}
    Writes JSON to stdout: {"response": "...", "success": true, ...}
    """
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            request = json.loads(line)
            prompt = request.get("prompt", "")
            max_turns = request.get("max_turns", 5)

            if not prompt:
                result = {"success": False, "error": "No prompt provided"}
            else:
                result = await run_agent(prompt, max_turns)

            print(json.dumps(result), flush=True)

        except json.JSONDecodeError as e:
            print(
                json.dumps({"success": False, "error": f"Invalid JSON: {e}"}),
                flush=True,
            )
        except Exception as e:
            print(json.dumps({"success": False, "error": str(e)}), flush=True)


def main() -> int:
    """Main entry point."""
    if len(sys.argv) > 1:
        if sys.argv[1] == "--json":
            asyncio.run(json_mode())
        elif sys.argv[1] == "--help":
            print("Usage: agent.py [--json | --help]")
            print("  --json  JSON mode: read/write JSON lines from stdin/stdout")
            print("  (none)  Interactive mode: prompt-based conversation")
        else:
            # Single prompt mode
            prompt = " ".join(sys.argv[1:])
            result = asyncio.run(run_agent(prompt))
            print(json.dumps(result, indent=2))
    else:
        asyncio.run(interactive_mode())

    return 0


if __name__ == "__main__":
    sys.exit(main())
