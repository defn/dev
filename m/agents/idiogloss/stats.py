"""Content Statistics Computation.

Simple text analysis for displaying file metrics in the webview.

## Why Server-Side?

Stats could be computed in the webview (JavaScript), but doing it
server-side means:

1. Consistent implementation (Python vs JS edge cases)
2. Easy to extend with more complex analysis
3. Webview stays thin - just displays what server sends

## Metrics

- lines: Number of newline-separated lines
- words: Whitespace-separated tokens
- characters: Total character count
- characters_no_spaces: Characters excluding spaces and newlines
"""

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
