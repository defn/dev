"""MCP server that provides time, disk, and user tools."""

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
