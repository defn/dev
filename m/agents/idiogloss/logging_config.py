"""Logging configuration for idiogloss server."""

import logging
import sys
from pathlib import Path

LOG_FILE = Path("/tmp/idiogloss-server.log")


def setup_logging() -> logging.Logger:
    """Configure logging to file and stderr."""
    logger = logging.getLogger("idiogloss")
    logger.setLevel(logging.DEBUG)

    # File handler - verbose
    file_handler = logging.FileHandler(LOG_FILE, mode="a")
    file_handler.setLevel(logging.DEBUG)
    file_format = logging.Formatter(
        "%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    file_handler.setFormatter(file_format)

    # Stderr handler - info level
    stderr_handler = logging.StreamHandler(sys.stderr)
    stderr_handler.setLevel(logging.INFO)
    stderr_format = logging.Formatter("[server] %(message)s")
    stderr_handler.setFormatter(stderr_format)

    logger.addHandler(file_handler)
    logger.addHandler(stderr_handler)

    return logger


# Global logger instance
log = setup_logging()
