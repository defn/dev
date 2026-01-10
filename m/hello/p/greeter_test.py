"""Tests for the greeter module."""

import unittest

from hello.p import greeter


class TestGreeter(unittest.TestCase):
    """Test cases for greeter functions."""

    def test_greet_simple(self) -> None:
        """Test basic greeting."""
        self.assertEqual(greeter.greet("World"), "Hello, World")

    def test_greet_empty(self) -> None:
        """Test greeting with empty name."""
        self.assertEqual(greeter.greet(""), "Hello, ")

    def test_greet_with_spaces(self) -> None:
        """Test greeting with spaces in name."""
        self.assertEqual(greeter.greet("Go Developer"), "Hello, Go Developer")

    def test_uppercase_lowercase(self) -> None:
        """Test uppercase with lowercase input."""
        self.assertEqual(greeter.uppercase("hello"), "HELLO")

    def test_uppercase_mixed(self) -> None:
        """Test uppercase with mixed case input."""
        self.assertEqual(greeter.uppercase("Hello World"), "HELLO WORLD")

    def test_uppercase_already_upper(self) -> None:
        """Test uppercase with already uppercase input."""
        self.assertEqual(greeter.uppercase("HELLO"), "HELLO")

    def test_decorate_simple(self) -> None:
        """Test decoration of a simple string."""
        self.assertEqual(greeter.decorate("Hello"), "*** Hello ***")

    def test_decorate_empty(self) -> None:
        """Test decoration of empty string."""
        self.assertEqual(greeter.decorate(""), "***  ***")


if __name__ == "__main__":
    unittest.main()
