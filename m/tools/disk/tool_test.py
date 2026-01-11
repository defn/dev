"""Tests for the disk tool."""

import asyncio
import json
import shutil
import unittest

from tools.disk.tool import get_disk_tool


class TestDiskTool(unittest.TestCase):
    """Test cases for the disk tool."""

    def test_get_disk_returns_json(self) -> None:
        """Test that get_disk returns valid JSON."""
        result = asyncio.run(get_disk_tool.handler({}))
        self.assertIn("content", result)
        data = json.loads(result["content"][0]["text"])
        self.assertIn("total_bytes", data)
        self.assertIn("used_bytes", data)
        self.assertIn("free_bytes", data)
        self.assertIn("percent_used", data)

    def test_get_disk_default_path(self) -> None:
        """Test disk usage for default root path."""
        result = asyncio.run(get_disk_tool.handler({}))
        data = json.loads(result["content"][0]["text"])
        self.assertEqual(data["path"], "/")

    def test_get_disk_custom_path(self) -> None:
        """Test disk usage for custom path."""
        result = asyncio.run(get_disk_tool.handler({"path": "/tmp"}))
        data = json.loads(result["content"][0]["text"])
        self.assertEqual(data["path"], "/tmp")

    def test_get_disk_matches_shutil(self) -> None:
        """Test that reported values match shutil.disk_usage."""
        result = asyncio.run(get_disk_tool.handler({"path": "/"}))
        data = json.loads(result["content"][0]["text"])
        actual = shutil.disk_usage("/")
        self.assertEqual(data["total_bytes"], actual.total)

    def test_get_disk_invalid_path(self) -> None:
        """Test error handling for invalid path."""
        result = asyncio.run(get_disk_tool.handler({"path": "/nonexistent/path/12345"}))
        self.assertTrue(result.get("is_error", False))


if __name__ == "__main__":
    unittest.main()
