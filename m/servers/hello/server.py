"""MCP Server Factory - In-Process Tool Server for Claude Agents.

This module creates MCP (Model Context Protocol) servers that can be
embedded directly in Python agents, avoiding subprocess overhead.

## What is MCP?

MCP is Anthropic's protocol for giving Claude access to external tools.
Typically MCP servers run as separate processes communicating via JSON-RPC.
This implementation runs in-process for lower latency.

## In-Process vs Subprocess

Traditional MCP:
    Claude API <-> Agent <-> Subprocess <-> MCP Server <-> Tools

In-Process MCP:
    Claude API <-> Agent <-> In-Process MCP Server <-> Tools

Benefits:
- No subprocess spawn overhead
- Direct function calls instead of JSON-RPC
- Simpler deployment (single binary/process)
- Easier debugging (single stack trace)

## Usage

    from servers.hello.server import create_hello_server
    from claude_agent_sdk import ClaudeAgentOptions, ClaudeSDKClient

    options = ClaudeAgentOptions(
        mcp_servers={"hello": create_hello_server()},
        allowed_tools=["mcp__hello__get_time", ...]
    )

## Tool Naming Convention

MCP tools are namespaced: `mcp__{server}__{tool}`

- `mcp__hello__get_time` - Time tool from "hello" server
- `mcp__hello__get_disk_usage` - Disk tool from "hello" server
- `mcp__hello__get_user_info` - User tool from "hello" server

The idiogloss agent uses a renamed server ("idiogloss_tools") so tools
become `mcp__idiogloss__get_time`, etc.
"""

from claude_agent_sdk import create_sdk_mcp_server
from tools.disk import get_disk_tool
from tools.time import get_time_tool
from tools.user import get_user_tool


def get_all_tools() -> list:
    """Return all available tools."""
    return [get_time_tool, get_disk_tool, get_user_tool]


def create_hello_server(name: str = "hello_tools", version: str = "1.0.0"):
    """Create an MCP server with all hello tools.

    Args:
        name: The server name.
        version: The server version.

    Returns:
        An McpSdkServerConfig for use with ClaudeAgentOptions.
    """
    return create_sdk_mcp_server(
        name=name,
        version=version,
        tools=get_all_tools(),
    )
