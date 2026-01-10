"""Tests for the MCP server."""

import unittest

from hello.mcp.server import create_hello_server, get_all_tools


class TestMcpServer(unittest.TestCase):
    """Test cases for the MCP server."""

    def test_get_all_tools_returns_three(self) -> None:
        """Test that get_all_tools returns all three tools."""
        tools = get_all_tools()
        self.assertEqual(len(tools), 3)

    def test_get_all_tools_has_correct_names(self) -> None:
        """Test that tools have the expected names."""
        tools = get_all_tools()
        names = {t.name for t in tools}
        self.assertEqual(names, {"get_time", "get_disk_usage", "get_user_info"})

    def test_create_hello_server(self) -> None:
        """Test that create_hello_server returns a valid config."""
        server = create_hello_server()
        self.assertIsNotNone(server)
        self.assertEqual(server["type"], "sdk")
        self.assertEqual(server["name"], "hello_tools")

    def test_create_hello_server_custom_name(self) -> None:
        """Test server creation with custom name."""
        server = create_hello_server(name="custom", version="2.0.0")
        self.assertEqual(server["name"], "custom")


if __name__ == "__main__":
    unittest.main()
