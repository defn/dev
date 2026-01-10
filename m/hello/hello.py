#!/usr/bin/env python3
"""Hello world demonstration using the p package and Claude Agent SDK.

This script demonstrates:
1. Using a local Python package (p/) within the same Bazel workspace
2. Using external pip packages (claude-agent-sdk)
3. Bazel py_binary configuration
4. MCP server integration with ClaudeSDKClient
5. Tool invocation and result verification
"""

import argparse
import asyncio
import os
import shutil
import sys
from datetime import datetime, timezone

from claude_agent_sdk import ClaudeAgentOptions, ClaudeSDKClient
from hello.mcp.server import create_hello_server
from hello.p import decorate, greet, uppercase


async def ask_claude_with_tools() -> dict:
    """Use ClaudeSDKClient with MCP tools to gather system information.

    Returns:
        A dict with the tool results and Claude's interpretation.
    """
    # Create the MCP server config
    mcp_server = create_hello_server()

    options = ClaudeAgentOptions(
        max_turns=5,
        mcp_servers=[mcp_server],
    )

    prompt = """Please use the available tools to gather information about this system:
1. Get the current time
2. Get disk usage for the root filesystem
3. Get the current user information

After gathering this information, provide a brief summary of what you found.
Format your response as:
TIME: <the unix timestamp you received>
DISK_TOTAL: <total bytes>
DISK_USED: <used bytes>
USER_UID: <uid number>
USER_GID: <gid number>
SUMMARY: <your brief summary>"""

    results = {
        "time_timestamp": None,
        "disk_total": None,
        "disk_used": None,
        "user_uid": None,
        "user_gid": None,
        "summary": None,
        "raw_response": "",
    }

    try:
        async with ClaudeSDKClient(options=options) as client:
            response = await client.process_prompt(prompt)

            # Extract text from the response
            if hasattr(response, "content"):
                for block in response.content:
                    if hasattr(block, "text"):
                        results["raw_response"] += block.text

            # Parse the structured response
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

    except Exception as e:
        results["error"] = str(e)

    return results


def verify_results(results: dict) -> tuple[bool, list[str]]:
    """Verify that Claude's tool results match actual system state.

    Args:
        results: The results dict from ask_claude_with_tools.

    Returns:
        A tuple of (all_passed, list of messages).
    """
    messages = []
    all_passed = True
    now = datetime.now(timezone.utc).timestamp()

    # Verify time is recent (within 60 seconds)
    if results.get("time_timestamp"):
        time_diff = abs(now - results["time_timestamp"])
        if time_diff <= 60:
            messages.append(f"[PASS] Time is recent (within {time_diff:.1f}s)")
        else:
            messages.append(f"[FAIL] Time is stale ({time_diff:.1f}s old)")
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse time from response")
        all_passed = False

    # Verify disk stats
    actual_disk = shutil.disk_usage("/")
    if results.get("disk_total"):
        # Allow 1% tolerance for rounding
        if abs(results["disk_total"] - actual_disk.total) / actual_disk.total < 0.01:
            messages.append(
                f"[PASS] Disk total matches ({results['disk_total']} bytes)"
            )
        else:
            messages.append(
                f"[FAIL] Disk total mismatch: got {results['disk_total']}, expected {actual_disk.total}"
            )
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse disk total from response")
        all_passed = False

    # Verify user info
    actual_uid = os.getuid()
    actual_gid = os.getgid()

    if results.get("user_uid") is not None:
        if results["user_uid"] == actual_uid:
            messages.append(f"[PASS] UID matches ({actual_uid})")
        else:
            messages.append(
                f"[FAIL] UID mismatch: got {results['user_uid']}, expected {actual_uid}"
            )
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse UID from response")
        all_passed = False

    if results.get("user_gid") is not None:
        if results["user_gid"] == actual_gid:
            messages.append(f"[PASS] GID matches ({actual_gid})")
        else:
            messages.append(
                f"[FAIL] GID mismatch: got {results['user_gid']}, expected {actual_gid}"
            )
            all_passed = False
    else:
        messages.append("[FAIL] Could not parse GID from response")
        all_passed = False

    return all_passed, messages


def main() -> int:
    """Main entry point for the hello command.

    Returns:
        Exit code (0 for success).
    """
    parser = argparse.ArgumentParser(
        description="Hello world with Python package and Claude SDK"
    )
    parser.add_argument(
        "name",
        nargs="?",
        default="World",
        help="Name to greet (default: World)",
    )
    parser.add_argument(
        "--uppercase",
        "-u",
        action="store_true",
        help="Convert greeting to uppercase",
    )
    parser.add_argument(
        "--decorate",
        "-d",
        action="store_true",
        help="Add decoration around greeting",
    )
    parser.add_argument(
        "--mcp-demo",
        "-m",
        action="store_true",
        help="Run MCP tools demo with ClaudeSDKClient",
    )
    parser.add_argument(
        "--verify",
        "-v",
        action="store_true",
        help="Verify MCP tool results match actual system state",
    )

    args = parser.parse_args()

    # Build greeting using the p package
    greeting = greet(args.name)

    if args.uppercase:
        greeting = uppercase(greeting)

    if args.decorate:
        greeting = decorate(greeting)

    print(greeting)

    # Run MCP tools demo
    if args.mcp_demo:
        print("\n" + "=" * 60)
        print("MCP Tools Demo with ClaudeSDKClient")
        print("=" * 60)

        results = asyncio.run(ask_claude_with_tools())

        if "error" in results:
            print(f"\nError: {results['error']}")
            return 1

        print("\nClaude's Response:")
        print("-" * 40)
        print(results.get("raw_response", "No response"))
        print("-" * 40)

        if args.verify:
            print("\nVerification Results:")
            passed, messages = verify_results(results)
            for msg in messages:
                print(f"  {msg}")

            if passed:
                print("\nAll verifications passed!")
            else:
                print("\nSome verifications failed!")
                return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
