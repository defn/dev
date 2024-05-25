#!/usr/bin/env bash

export CODER_AGENT_AUTH="token"

export CODER_AGENT_URL="$1"
shift
export DFD_WORKSPACE_NAME="$1"
export CODER_NAME="$1"
shift
export CODER_AGENT_TOKEN="$1"
shift

cd

ssh -o StrictHostKeyChecking=no git@github.com true || true

git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

case "$(git remote get-url origin)" in
http*)
	git remote rm origin
	git remote add origin https://github.com/defn/dev
	git fetch origin
	git branch --set-upstream-to=origin/main main
	;;
esac

git reset --hard origin/main

(
	set +x
	while true; do
		cd ~/m
		source .bash_profile
		coder::coder-agent "${CODER_NAME}" || true
		sleep 5
	done >>/tmp/coder-agent.log 2>&1
) &
disown
