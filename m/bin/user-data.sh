#!/usr/bin/env bash
set -eux

export CODER_AGENT_AUTH="token"
export CODER_AGENT_URL="$1"; shift
export CODER_AGENT_TOKEN="$1"; shift
shift

cd
source .bash_profile

cd ~/m/pkg/coder
exec nix develop --command coder agent
