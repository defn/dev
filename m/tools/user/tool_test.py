"""Tests for the user tool."""

import asyncio
import json
import os
import unittest

from tools.user.tool import get_user_tool


class TestUserTool(unittest.TestCase):
    """Test cases for the user tool."""

    def test_get_user_returns_json(self) -> None:
        """Test that get_user returns valid JSON."""
        result = asyncio.run(get_user_tool.handler({}))
        self.assertIn("content", result)
        data = json.loads(result["content"][0]["text"])
        self.assertIn("uid", data)
        self.assertIn("gid", data)
        self.assertIn("username", data)
        self.assertIn("groupname", data)

    def test_get_user_matches_os(self) -> None:
        """Test that reported values match os module values."""
        result = asyncio.run(get_user_tool.handler({}))
        data = json.loads(result["content"][0]["text"])
        self.assertEqual(data["uid"], os.getuid())
        self.assertEqual(data["gid"], os.getgid())


if __name__ == "__main__":
    unittest.main()
