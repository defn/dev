"""Tests for the user tool."""

import asyncio
import os
import unittest

from hello.tools.user.tool import get_user_tool


class TestUserTool(unittest.TestCase):
    """Test cases for the user tool."""

    def test_get_user_returns_content(self) -> None:
        """Test that get_user returns proper content structure."""
        result = asyncio.run(get_user_tool.handler({}))
        self.assertIn("content", result)
        self.assertEqual(len(result["content"]), 1)
        self.assertEqual(result["content"][0]["type"], "text")

    def test_get_user_contains_uid(self) -> None:
        """Test that the response contains the current UID."""
        result = asyncio.run(get_user_tool.handler({}))
        text = result["content"][0]["text"]
        uid = os.getuid()
        self.assertIn(f"UID: {uid}", text)

    def test_get_user_contains_gid(self) -> None:
        """Test that the response contains the current GID."""
        result = asyncio.run(get_user_tool.handler({}))
        text = result["content"][0]["text"]
        gid = os.getgid()
        self.assertIn(f"GID: {gid}", text)

    def test_get_user_matches_os(self) -> None:
        """Test that reported values match os module values."""
        result = asyncio.run(get_user_tool.handler({}))
        text = result["content"][0]["text"]

        self.assertIn(f"UID: {os.getuid()}", text)
        self.assertIn(f"GID: {os.getgid()}", text)
        self.assertIn(f"EUID: {os.geteuid()}", text)
        self.assertIn(f"EGID: {os.getegid()}", text)


if __name__ == "__main__":
    unittest.main()
