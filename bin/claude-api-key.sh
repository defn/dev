#!/bin/bash

set -euo pipefail

# Source Claude environment variables
if [[ -f ~/.env-shared/.env.claude ]]; then
    source ~/.env-shared/.env.claude
fi

# Echo the Anthropic API key
echo "${ANTHROPIC_API_KEY}"