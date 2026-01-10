"""Greeting utilities for the hello Python package."""


def greet(name: str) -> str:
    """Format a greeting with the given name.

    Args:
        name: The name to greet.

    Returns:
        A greeting string.
    """
    return f"Hello, {name}"


def uppercase(s: str) -> str:
    """Return the string in uppercase.

    Args:
        s: The string to convert.

    Returns:
        The uppercase string.
    """
    return s.upper()


def decorate(greeting: str) -> str:
    """Add decoration around a greeting.

    Args:
        greeting: The greeting to decorate.

    Returns:
        The decorated greeting.
    """
    return f"*** {greeting} ***"
