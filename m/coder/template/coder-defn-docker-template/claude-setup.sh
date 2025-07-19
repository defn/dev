#!/bin/bash

set -euo pipefail

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Path to settings file
SETTINGS_FILE="$HOME/.claude/settings.local.json"

# Create settings file if it doesn't exist or initialize empty JSON
if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo '{}' > "$SETTINGS_FILE"
fi

# Add or update apiKeyHelper setting
jq --arg helper_path "$HOME/bin/claude-api-key.sh" \
   '.apiKeyHelper = $helper_path' \
   "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && \
   mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "Updated $SETTINGS_FILE with apiKeyHelper: $HOME/bin/claude-api-key.sh"