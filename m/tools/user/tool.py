"""MCP tool that returns current user and group information."""

import grp
import json
import os
import pwd
from typing import Any

from claude_agent_sdk import tool


@tool("get_user_info", "Get current user and group information as JSON", {})
async def get_user_tool(args: dict[str, Any]) -> dict[str, Any]:
    """Return current user and group information as JSON."""
    uid = os.getuid()
    gid = os.getgid()

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
        group_names = []

    data = {
        "uid": uid,
        "gid": gid,
        "username": username,
        "groupname": groupname,
        "home": home_dir,
        "shell": shell,
        "groups": group_names,
    }

    return {"content": [{"type": "text", "text": json.dumps(data)}]}
