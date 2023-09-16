#!/usr/bin/env bash
#export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_AUTH="token"
export CODER_AGENT_URL="$1"; shift
export DFD_WORKSPACE_NAME="$1"; shift

cd
set +x
source .bash_profile
set -x

(
    cd ~/m/pkg/awscli
    nix develop --command bash -c "aws secretsmanager get-secret-value --secret-id "${DFD_WORKSPACE_NAME}" | jq -r '.SecretString | fromjson | .coder_agent_token' > /tmp/.coder-token"
)
export CODER_AGENT_TOKEN="$(cat /tmp/.coder_token)"
echo rm -f /tmp/.coder_token

cd ~/m/pkg/coder
exec nix develop --command coder agent
