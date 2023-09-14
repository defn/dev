#!/usr/bin/env sh
set -eux

export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_URL="$1"
shift

cd ~/m/pkg/coder
nix develop --command coder agent
