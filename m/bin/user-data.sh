#!/usr/bin/env bash
set -eux

export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_URL="$1"
shift

cd
source .bash_profile

cd ~/m/pkg/coder
exec nix develop --command coder agent
