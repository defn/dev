#!/bin/bash

set -euo pipefail

# Change to home directory
cd "$HOME"

# Pull latest changes from git
git pull

~/bin/clause-setup-inner.sh "$@"
