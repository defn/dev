#!/usr/bin/env bash

export CODER_AGENT_AUTH="token"

export CODER_AGENT_URL="$1"
shift
export DFD_WORKSPACE_NAME="$1"
shift
export CODER_AGENT_TOKEN="$1"
shift

cd

ssh -o StrictHostKeyChecking=no git@github.com true || true

git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

case "$(git remote get-url origin)" in
http*)
	git remote rm origin
	git remote add origin git@github.com:defn/dev
	git fetch origin
	git branch --set-upstream-to=origin/main main
	;;
esac

case "$(git remote get-url pub || true)" in
http*)
	true
	;;
*)
	git remote rm pub
	git remote add pub https://github.com/defn/dev
	git fetch pub
	;;
esac

git merge pub/main
git branch -u origin/main

(
	set +x
	while true; do
		cd
		source .bash_profile
		coder agent || true
		sleep 5
	done >>/tmp/coder-agent.log 2>&1
) &
disown
