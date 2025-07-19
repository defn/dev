#!/bin/bash

set -euo pipefail

# Source Claude environment variables
if [[ -f ~/.env.claude ]]; then
    source ~/.env.claude
fi

# Echo the Anthropic API key
echo "${ANTHROPIC_API_KEY}"