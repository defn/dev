"""Tests for the disk tool."""

import asyncio
import shutil
import unittest

from hello.tools.disk.tool import get_disk_tool


class TestDiskTool(unittest.TestCase):
    """Test cases for the disk tool."""

    def test_get_disk_returns_content(self) -> None:
        """Test that get_disk returns proper content structure."""
        result = asyncio.run(get_disk_tool.handler({}))
        self.assertIn("content", result)
        self.assertEqual(len(result["content"]), 1)
        self.assertEqual(result["content"][0]["type"], "text")

    def test_get_disk_default_path(self) -> None:
        """Test disk usage for default root path."""
        result = asyncio.run(get_disk_tool.handler({}))
        text = result["content"][0]["text"]
        self.assertIn("Disk usage for '/'", text)
        self.assertIn("Total:", text)
        self.assertIn("Used:", text)
        self.assertIn("Free:", text)

    def test_get_disk_custom_path(self) -> None:
        """Test disk usage for custom path."""
        result = asyncio.run(get_disk_tool.handler({"path": "/tmp"}))
        text = result["content"][0]["text"]
        self.assertIn("Disk usage for '/tmp'", text)

    def test_get_disk_matches_shutil(self) -> None:
        """Test that reported values match shutil.disk_usage."""
        result = asyncio.run(get_disk_tool.handler({"path": "/"}))
        text = result["content"][0]["text"]

        actual = shutil.disk_usage("/")

        # Check that the total bytes value appears in the output
        self.assertIn(str(actual.total), text)

    def test_get_disk_invalid_path(self) -> None:
        """Test error handling for invalid path."""
        result = asyncio.run(get_disk_tool.handler({"path": "/nonexistent/path/12345"}))
        self.assertTrue(result.get("is_error", False))


if __name__ == "__main__":
    unittest.main()
