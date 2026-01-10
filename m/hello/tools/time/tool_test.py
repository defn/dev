"""Tests for the time tool."""

import asyncio
import unittest
from datetime import datetime, timezone

from hello.tools.time.tool import get_time_tool


class TestTimeTool(unittest.TestCase):
    """Test cases for the time tool."""

    def test_get_time_returns_content(self) -> None:
        """Test that get_time returns proper content structure."""
        result = asyncio.run(get_time_tool.handler({}))
        self.assertIn("content", result)
        self.assertEqual(len(result["content"]), 1)
        self.assertEqual(result["content"][0]["type"], "text")

    def test_get_time_contains_timestamp(self) -> None:
        """Test that the response contains a unix timestamp."""
        result = asyncio.run(get_time_tool.handler({}))
        text = result["content"][0]["text"]
        self.assertIn("Unix timestamp:", text)

    def test_get_time_is_recent(self) -> None:
        """Test that the returned time is recent (within 5 seconds)."""
        before = datetime.now(timezone.utc).timestamp()
        result = asyncio.run(get_time_tool.handler({}))
        after = datetime.now(timezone.utc).timestamp()

        text = result["content"][0]["text"]
        # Extract timestamp from the response
        for line in text.split("\n"):
            if "Unix timestamp:" in line:
                timestamp = float(line.split(":")[1].strip())
                self.assertGreaterEqual(timestamp, before)
                self.assertLessEqual(timestamp, after)
                break


if __name__ == "__main__":
    unittest.main()
