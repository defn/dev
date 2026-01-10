#!/usr/bin/env python3
"""MCP server providing time, disk, and user information tools.

This server can be run standalone and used by any MCP-compatible client
like Claude CLI or other agent frameworks.

Usage:
    # Run directly
    python hello_mcp.py

    # Or via bazel
    bazel run //hello:hello_mcp

    # Configure in Claude CLI settings as:
    {
        "mcpServers": {
            "hello": {
                "command": "bazel",
                "args": ["run", "//hello:hello_mcp"]
            }
        }
    }
"""

import asyncio
import sys

from hello.tools.disk.tool import get_disk_tool
from hello.tools.time.tool import get_time_tool
from hello.tools.user.tool import get_user_tool
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import TextContent, Tool

# Create the MCP server
server = Server("hello_tools")


@server.list_tools()
async def list_tools() -> list[Tool]:
    """List all available tools."""
    return [
        Tool(
            name="get_time",
            description="Get the current date and time in ISO format with timezone",
            inputSchema={"type": "object", "properties": {}, "required": []},
        ),
        Tool(
            name="get_disk_usage",
            description="Get disk usage statistics for a given path (default: root filesystem)",
            inputSchema={
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to check disk usage for",
                    }
                },
                "required": [],
            },
        ),
        Tool(
            name="get_user_info",
            description="Get current user and group ID with names",
            inputSchema={"type": "object", "properties": {}, "required": []},
        ),
    ]


@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Handle tool calls."""
    if name == "get_time":
        result = await get_time_tool.handler(arguments)
    elif name == "get_disk_usage":
        result = await get_disk_tool.handler(arguments)
    elif name == "get_user_info":
        result = await get_user_tool.handler(arguments)
    else:
        return [TextContent(type="text", text=f"Unknown tool: {name}")]

    # Extract text from the result
    content = result.get("content", [])
    return [
        TextContent(type="text", text=item.get("text", ""))
        for item in content
        if item.get("type") == "text"
    ]


async def main() -> int:
    """Run the MCP server."""
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream, write_stream, server.create_initialization_options()
        )
    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
