#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export DEBIAN_FRONTEND=noninteractive

	sudo apt update || true

	# sync with m/i/Dockerfile, m/i/script/001-install-base
	sudo apt install -y \
		make direnv curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
		build-essential sudo ca-certificates tzdata locales git git-lfs tini \
		iproute2 iptables bc pv socat s6 cpu-checker bind9-dnsutils \
		pass ||
		true

	if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi

	source .bash_profile

	make sync
	make install

	git checkout .docker
	sudo ./fixup.sh || true
}

main "$@"
