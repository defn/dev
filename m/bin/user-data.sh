#!/usr/bin/env bash

exec 3>&1
exec >>/tmp/dfd-user-data.log 2>&1
tail -f /tmp/dfd-user-data.log 1>&3 &

#export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_AUTH="token"
export CODER_AGENT_URL="$1"; shift
export DFD_WORKSPACE_NAME="$1"; shift

cd
set +x
source .bash_profile
set -x

export CODER_AGENT_TOKEN

while true; do
  CODER_AGENT_TOKEN=

  cd ~/m/pkg/coder

  TOKEN="$(curl -sSL -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
  instance_id="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)"

  cd ~/m/pkg/coder
  nix develop --command true

  cd ~/m/pkg/awscli
  nix develop --command bash -c "aws secretsmanager get-secret-value --secret-id "${DFD_WORKSPACE_NAME}-${instance_id}" | jq -r '.SecretString | fromjson | .coder_agent_token' > /tmp/.coder-token" || true
  CODER_AGENT_TOKEN="$(cat /tmp/.coder-token)"
  echo rm -f /tmp/.coder-token

  cd ~/m/pkg/coder
  nix develop --command coder agent || true

  sleep 5
done

