#!/bin/bash

set -euo pipefail

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Change ownership of .claude directory to ubuntu:ubuntu
sudo chown -R ubuntu:ubuntu ~/.claude

# Copy authentication from host if available
if [[ -f ~/.claude-host/.credentials.json ]]; then
	cp ~/.claude-host/.credentials.json ~/.claude/
	echo "Copied authentication from host to ~/.claude/.credentials.json"
else
	echo "No host authentication found at ~/.claude-host/.credentials.json"
fi
