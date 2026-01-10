#!/usr/bin/env python3
"""Agentic example using Claude Agent SDK with MCP tools.

This script demonstrates:
1. Creating an MCP server with custom tools
2. Using ClaudeSDKClient to run an agent with tool access
3. Verifying tool results match actual system state
"""

import asyncio
import os
import shutil
import sys
from datetime import datetime, timezone

from claude_agent_sdk import ClaudeAgentOptions, ClaudeSDKClient
from hello.mcp.server import create_hello_server


async def run_agent() -> dict:
    """Run Claude agent with MCP tools to gather system information.

    Returns:
        A dict with the tool results and Claude's interpretation.
    """
    mcp_server = create_hello_server()

    options = ClaudeAgentOptions(
        max_turns=5,
        mcp_servers={"hello": mcp_server},
        allowed_tools=[
            "mcp__hello__get_time",
            "mcp__hello__get_disk_usage",
            "mcp__hello__get_user_info",
        ],
    )

    prompt = """Use the available tools to gather system information:
1. Get the current time
2. Get disk usage for /
3. Get the current user info

Then provide a structured response:
TIME: <unix timestamp>
DISK_TOTAL: <total bytes>
DISK_USED: <used bytes>
USER_UID: <uid>
USER_GID: <gid>
SUMMARY: <one line summary>"""

    results = {
        "time_timestamp": None,
        "disk_total": None,
        "disk_used": None,
        "user_uid": None,
        "user_gid": None,
        "summary": None,
        "raw_response": "",
    }

    async with ClaudeSDKClient(options=options) as client:
        await client.query(prompt)
        async for msg in client.receive_response():
            # Extract text from ResultMessage (final response)
            if hasattr(msg, "result") and msg.result:
                results["raw_response"] = msg.result
            # Or from AssistantMessage content blocks
            elif hasattr(msg, "content"):
                for block in msg.content:
                    if hasattr(block, "text"):
                        results["raw_response"] += block.text

        # Parse structured response
        for line in results["raw_response"].split("\n"):
            line = line.strip()
            if line.startswith("TIME:"):
                try:
                    results["time_timestamp"] = float(line.split(":", 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith("DISK_TOTAL:"):
                try:
                    results["disk_total"] = int(line.split(":", 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith("DISK_USED:"):
                try:
                    results["disk_used"] = int(line.split(":", 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith("USER_UID:"):
                try:
                    results["user_uid"] = int(line.split(":", 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith("USER_GID:"):
                try:
                    results["user_gid"] = int(line.split(":", 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith("SUMMARY:"):
                results["summary"] = line.split(":", 1)[1].strip()

    return results


def verify_results(results: dict) -> tuple[bool, list[str]]:
    """Verify Claude's tool results match actual system state."""
    messages = []
    all_passed = True
    now = datetime.now(timezone.utc).timestamp()

    # Verify time is recent (within 60 seconds)
    if results.get("time_timestamp"):
        time_diff = abs(now - results["time_timestamp"])
        if time_diff <= 60:
            messages.append(f"[PASS] Time is recent ({time_diff:.1f}s)")
        else:
            messages.append(f"[FAIL] Time is stale ({time_diff:.1f}s old)")
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse time")
        all_passed = False

    # Verify disk stats
    actual_disk = shutil.disk_usage("/")
    if results.get("disk_total"):
        if abs(results["disk_total"] - actual_disk.total) / actual_disk.total < 0.01:
            messages.append(f"[PASS] Disk total matches ({results['disk_total']})")
        else:
            messages.append(
                f"[FAIL] Disk mismatch: {results['disk_total']} vs {actual_disk.total}"
            )
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse disk total")
        all_passed = False

    # Verify user info
    actual_uid = os.getuid()
    actual_gid = os.getgid()

    if results.get("user_uid") is not None:
        if results["user_uid"] == actual_uid:
            messages.append(f"[PASS] UID matches ({actual_uid})")
        else:
            messages.append(f"[FAIL] UID: {results['user_uid']} vs {actual_uid}")
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse UID")
        all_passed = False

    if results.get("user_gid") is not None:
        if results["user_gid"] == actual_gid:
            messages.append(f"[PASS] GID matches ({actual_gid})")
        else:
            messages.append(f"[FAIL] GID: {results['user_gid']} vs {actual_gid}")
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse GID")
        all_passed = False

    return all_passed, messages


def main() -> int:
    """Run the agent and verify results."""
    print("Running Claude agent with MCP tools...")
    print("=" * 50)

    results = asyncio.run(run_agent())

    print("\nAgent Response:")
    print("-" * 50)
    print(results.get("raw_response", "No response"))
    print("-" * 50)

    print("\nVerification:")
    passed, messages = verify_results(results)
    for msg in messages:
        print(f"  {msg}")

    if passed:
        print("\nAll checks passed!")
        return 0
    else:
        print("\nSome checks failed!")
        return 1


if __name__ == "__main__":
    sys.exit(main())
