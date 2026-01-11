#!/usr/bin/env python3
"""Unix socket server for idiogloss agent.

Listens on a Unix socket and handles JSON requests from the VS Code extension.
"""

import asyncio
import json
import os
import signal
import sys
from pathlib import Path
from typing import Any

from agents.idiogloss.handlers import dispatch_request
from agents.idiogloss.logging_config import log

# Default socket path
DEFAULT_SOCKET_PATH = "/tmp/idiogloss.sock"


class IdioglossServer:
    """Unix socket server for idiogloss agent."""

    def __init__(self, socket_path: str = DEFAULT_SOCKET_PATH):
        self.socket_path = socket_path
        self.server: asyncio.Server | None = None
        self._running = False

    async def handle_client(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter,
    ) -> None:
        """Handle a client connection."""
        peer = writer.get_extra_info("peername") or "unknown"
        log.info(f"Client connected: {peer}")
        log.debug(f"Connection details: socket={self.socket_path}, peer={peer}")

        try:
            while True:
                log.debug("Waiting for request...")
                line = await reader.readline()
                if not line:
                    log.debug("Client sent empty line, disconnecting")
                    break

                try:
                    request = json.loads(line.decode().strip())
                    action = request.get("action", "unknown")
                    log.debug(f"Received request: action={action}")
                    response = await dispatch_request(
                        request,
                        shutdown_callback=self._trigger_shutdown,
                    )
                    log.debug(f"Response: success={response.get('success')}")
                except json.JSONDecodeError as e:
                    log.error(f"Invalid JSON: {e}")
                    response = {"success": False, "error": f"Invalid JSON: {e}"}
                except Exception as e:
                    log.error(f"Request error: {e}")
                    response = {"success": False, "error": str(e)}

                response_line = json.dumps(response) + "\n"
                writer.write(response_line.encode())
                await writer.drain()
                log.debug("Response sent")

        except asyncio.CancelledError:
            log.debug("Client handler cancelled")
        except Exception as e:
            log.error(f"Client error: {e}")
        finally:
            writer.close()
            await writer.wait_closed()
            log.info(f"Client disconnected: {peer}")

    def _trigger_shutdown(self) -> None:
        """Trigger server shutdown."""
        self._running = False

    async def start(self) -> None:
        """Start the server."""
        log.info(f"Starting server on {self.socket_path}")
        log.debug(f"PID: {os.getpid()}")

        socket_path = Path(self.socket_path)
        if socket_path.exists():
            log.debug(f"Removing existing socket file: {socket_path}")
            socket_path.unlink()

        socket_path.parent.mkdir(parents=True, exist_ok=True)

        self.server = await asyncio.start_unix_server(
            self.handle_client,
            path=self.socket_path,
        )

        os.chmod(self.socket_path, 0o600)

        self._running = True
        log.info(f"Server listening on {self.socket_path}")
        log.debug("Entering main loop, waiting for connections...")

        async with self.server:
            while self._running:
                await asyncio.sleep(0.1)

    async def stop(self) -> None:
        """Stop the server."""
        log.info("Stopping server...")
        self._running = False
        if self.server:
            self.server.close()
            await self.server.wait_closed()

        socket_path = Path(self.socket_path)
        if socket_path.exists():
            socket_path.unlink()
            log.debug(f"Removed socket file: {socket_path}")

        log.info("Server stopped")


async def main() -> int:
    """Run the server."""
    socket_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SOCKET_PATH

    log.info("=" * 50)
    log.info("Idiogloss server starting")
    log.debug(f"Socket path: {socket_path}")
    log.debug(f"Arguments: {sys.argv}")

    server = IdioglossServer(socket_path)

    loop = asyncio.get_running_loop()

    def shutdown_handler():
        log.info("Received shutdown signal")
        asyncio.create_task(server.stop())

    for sig in (signal.SIGINT, signal.SIGTERM):
        loop.add_signal_handler(sig, shutdown_handler)

    try:
        await server.start()
    except Exception as e:
        log.error(f"Server error: {e}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
