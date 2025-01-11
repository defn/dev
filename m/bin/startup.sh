#!/usr/bin/env bash

set -e

function main {
	cd
	source .bash_profile

	if [[ -n "${KUBERNETES_PORT_443_TCP:-}" ]]; then
		sudo chown ubuntu:ubuntu ~/.local
		(cd ~/m && setsid j coder::code-server "${CODER_NAME}" >>/tmp/code-server.log 2>&1 &) &
	else
		(
			cd ~/m/cache/docker
			make init
		)
		k3d cluster start k3s-default
		k3d kubeconfig get k3s-default > ~/.kube/config
		(
			set +x
			cd m
			while true; do
				cd
				source .bash_profile
				cd ~/m
				j coder::code-server "${CODER_NAME}" || true &
				sleep 5
			done >>/tmp/code-server.log 2>&1
		) &
		disown
	fi

	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

	case "$(git remote get-url origin)" in
	http*)
		git remote rm origin
		git remote add origin https://github.com/defn/dev
		git fetch origin
		git branch --set-upstream-to=origin/main main
		git reset --hard origin/main
		;;
	esac

	git pull

	if [[ -n "${KUBERNETES_PORT_443_TCP:-}" ]]; then
		(sleep 10; pkill -f bin/startup.sh || true) &
		exit 0
	fi
}

time main "$@"
