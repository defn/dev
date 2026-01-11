"""Logging Configuration for Idiogloss Server.

Dual-output logging: detailed file logs + concise stderr.

## Why Two Handlers?

1. **File handler** (DEBUG level): Full history for debugging
   - Location: /tmp/idiogloss-server.log
   - Format: timestamps, log levels, full messages
   - Persists across sessions

2. **Stderr handler** (INFO level): VS Code Output channel
   - Format: [server] prefix for easy filtering
   - Shows in extension's output panel
   - Avoids debug spam in normal operation

## Log Levels

- DEBUG: Connection details, request/response payloads
- INFO: Startup, shutdown, client connect/disconnect
- ERROR: Exceptions, JSON parse failures

## Usage

    from agents.idiogloss.logging_config import log

    log.info("Server started")
    log.debug(f"Request: {request}")
    log.error(f"Failed: {e}")
"""

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
