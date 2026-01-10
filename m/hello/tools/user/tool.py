"""MCP tool that returns current user and group information."""

import grp
import os
import pwd
from typing import Any

from claude_agent_sdk import tool


@tool("get_user_info", "Get current user and group ID with names", {})
async def get_user_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return current user and group information."""
    uid = os.getuid()
    gid = os.getgid()
    euid = os.geteuid()
    egid = os.getegid()

    try:
        user_info = pwd.getpwuid(uid)
        username = user_info.pw_name
        home_dir = user_info.pw_dir
        shell = user_info.pw_shell
    except KeyError:
        username = "unknown"
        home_dir = "unknown"
        shell = "unknown"

    try:
        group_info = grp.getgrgid(gid)
        groupname = group_info.gr_name
    except KeyError:
        groupname = "unknown"

    # Get supplementary groups
    try:
        groups = os.getgroups()
        group_names = []
        for g in groups:
            try:
                group_names.append(grp.getgrgid(g).gr_name)
            except KeyError:
                group_names.append(str(g))
    except OSError:
        groups = []
        group_names = []

    return {
        "content": [
            {
                "type": "text",
                "text": (
                    f"User information:\n"
                    f"  UID: {uid} ({username})\n"
                    f"  GID: {gid} ({groupname})\n"
                    f"  EUID: {euid}\n"
                    f"  EGID: {egid}\n"
                    f"  Home: {home_dir}\n"
                    f"  Shell: {shell}\n"
                    f"  Groups: {', '.join(group_names) or 'none'}"
                ),
            }
        ]
    }
