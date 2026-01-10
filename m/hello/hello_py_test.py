"""Tests for the hello.py script functionality."""

import unittest

from hello.p import decorate, greet, uppercase


class TestHelloPy(unittest.TestCase):
    """Test cases for hello.py using the p package."""

    def test_greet(self) -> None:
        """Test the greet function from p package."""
        self.assertEqual(greet("World"), "Hello, World")
        self.assertEqual(greet("Python"), "Hello, Python")

    def test_uppercase(self) -> None:
        """Test the uppercase function from p package."""
        self.assertEqual(uppercase("hello"), "HELLO")
        self.assertEqual(uppercase("Hello, World"), "HELLO, WORLD")

    def test_decorate(self) -> None:
        """Test the decorate function from p package."""
        self.assertEqual(decorate("Hello"), "*** Hello ***")

    def test_combined(self) -> None:
        """Test combining greet, uppercase, and decorate."""
        greeting = greet("Bazel")
        greeting = uppercase(greeting)
        greeting = decorate(greeting)
        self.assertEqual(greeting, "*** HELLO, BAZEL ***")


if __name__ == "__main__":
    unittest.main()
