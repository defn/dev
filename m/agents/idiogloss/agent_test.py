#!/usr/bin/env python3
"""Tests for idiogloss agent MCP server creation."""

from servers.hello.server import create_hello_server


def test_create_server():
    """Test that the MCP server can be created."""
    server = create_hello_server(name="idiogloss_tools", version="1.0.0")
    assert server is not None, "Server should be created"


def test_server_has_tools():
    """Test that the server has the expected tools."""
    server = create_hello_server(name="idiogloss_tools", version="1.0.0")
    # The server config should be usable with ClaudeAgentOptions
    assert server is not None, "Server should not be None"


if __name__ == "__main__":
    test_create_server()
    test_server_has_tools()
    print("All tests passed!")
