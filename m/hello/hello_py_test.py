"""Tests for the hello.py agent script."""

import unittest

from hello.mcp.server import create_hello_server, get_all_tools


class TestHelloPy(unittest.TestCase):
    """Test cases for hello.py agent."""

    def test_mcp_server_creation(self) -> None:
        """Test that MCP server can be created."""
        server = create_hello_server()
        self.assertIsNotNone(server)

    def test_tools_available(self) -> None:
        """Test that all tools are available."""
        tools = get_all_tools()
        self.assertEqual(len(tools), 3)
        tool_names = [t.name for t in tools]
        self.assertIn("get_time", tool_names)
        self.assertIn("get_disk_usage", tool_names)
        self.assertIn("get_user_info", tool_names)


if __name__ == "__main__":
    unittest.main()
