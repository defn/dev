#!/usr/bin/env bash

set -efu -o pipefail

function main {
	sudo apt update
	# sync with m/Dockerfile
	sudo apt install -y make direnv curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync build-essential sudo ca-certificates tzdata locales git git-lfs tini iproute2 iptables bc pv socat docker.io s6
	source .bash_profile
	make install
	make sync
	make install
}

main "$@"
