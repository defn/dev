#!/usr/bin/env bash
export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_URL="$1"; shift

cd
set +x
source .bash_profile
set -x

cd ~/m/pkg/coder
exec nix develop --command coder agent
