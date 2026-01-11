"""Tests for the time tool."""

import asyncio
import json
import unittest
from datetime import datetime, timezone

from tools.time.tool import get_time_tool


class TestTimeTool(unittest.TestCase):
    """Test cases for the time tool."""

    def test_get_time_returns_json(self) -> None:
        """Test that get_time returns valid JSON."""
        result = asyncio.run(get_time_tool.handler({}))
        self.assertIn("content", result)
        text = result["content"][0]["text"]
        data = json.loads(text)
        self.assertIn("timestamp", data)
        self.assertIn("utc", data)
        self.assertIn("local", data)

    def test_get_time_is_recent(self) -> None:
        """Test that the returned time is recent (within 5 seconds)."""
        before = datetime.now(timezone.utc).timestamp()
        result = asyncio.run(get_time_tool.handler({}))
        after = datetime.now(timezone.utc).timestamp()

        data = json.loads(result["content"][0]["text"])
        self.assertGreaterEqual(data["timestamp"], before)
        self.assertLessEqual(data["timestamp"], after)


if __name__ == "__main__":
    unittest.main()
