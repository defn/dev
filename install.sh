#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export DEBIAN_FRONTEND=noninteractive

	sudo apt update

	# sync with m/Dockerfile, m/i/script/001-install-base
	sudo apt install -y \
		make direnv curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
		build-essential sudo ca-certificates tzdata locales git git-lfs tini \
		iproute2 iptables bc pv socat docker.io s6 cpu-checker bind9-dnsutils \
		pass
	
	if ! test -e .docker/config.json; then
		cp .docker/config.json.example .docker/config.json
	fi

	source .bash_profile

	make sync
	make install
}

main "$@"
