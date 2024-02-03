#!/usr/bin/env bash

#export CODER_AGENT_AUTH="aws-instance-identity"
export CODER_AGENT_AUTH="token"
export CODER_AGENT_URL="$1"
shift
export DFD_WORKSPACE_NAME="$1"
shift

cd

ssh -o StrictHostKeyChecking=no git@github.com true || true

case "$(git remote get-url origin)" in
http*)
	git remote rm origin
	git remote add origin git@github.com:defn/dev
	git fetch origin
	git branch --set-upstream-to=origin/main main
	;;
esac
git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

set +x
source .bash_profile
set -x

export CODER_AGENT_TOKEN

TOKEN="$(curl -sSL -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
instance_id="$(curl -sSL -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)"

aws secretsmanager get-secret-value --secret-id "${DFD_WORKSPACE_NAME}-${instance_id}" | jq -r '.SecretString' >/tmp/.coder-token
CODER_AGENT_TOKEN="$(cat /tmp/.coder-token)"

coder agent >/tmp/user-data.log 2>&1 &
disown
