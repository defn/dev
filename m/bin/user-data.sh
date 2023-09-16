#!/usr/bin/env bash
#export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_AUTH="token"
export CODER_AGENT_URL="$1"; shift
export DFD_WORKSPACE_NAME="$1"; shift

cd
set +x
source .bash_profile
set -x

export CODER_AGENT_TOKEN
CODER_AGENT_TOKEN=

while [[ -z "${CODER_AGENT_TOKEN}" ]]; do
    (
        TOKEN="$(curl -sSL -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
        instance_id="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)"
        cd ~/m/pkg/coder
        exec nix develop --command true
        cd ~/m/pkg/awscli
        nix develop --command bash -c "aws secretsmanager get-secret-value --secret-id "${DFD_WORKSPACE_NAME}-${instance_id}" | jq -r '.SecretString | fromjson | .coder_agent_token' > /tmp/.coder-token" || true
    )
    CODER_AGENT_TOKEN="$(cat /tmp/.coder_token)"
    echo rm -f /tmp/.coder_token
    if [[ -z "${CODER_AGENT_TOKEN}" ]]; then
        sleep 5
    fi
done

cd ~/m/pkg/coder
exec nix develop --command coder agent
