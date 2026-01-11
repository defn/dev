"""Content statistics computation."""

from typing import Any


def compute_stats(content: str) -> dict[str, Any]:
    """Compute statistics for content."""
    lines = content.split("\n")
    line_count = len(lines)
    word_count = sum(len(line.split()) for line in lines)
    char_count = len(content)
    char_count_no_spaces = len(content.replace(" ", "").replace("\n", ""))

    return {
        "lines": line_count,
        "words": word_count,
        "characters": char_count,
        "characters_no_spaces": char_count_no_spaces,
    }
