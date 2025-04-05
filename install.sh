#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export DEBIAN_FRONTEND=noninteractive

	sudo apt update

	# sync with m/i/Dockerfile, m/i/install-packer.sh
	sudo apt install -y \
		make curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
		build-essential sudo ca-certificates tzdata locales git git-lfs tini \
		iproute2 iptables bc pv socat s6 cpu-checker bind9-dnsutils \
		pass skopeo

	if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi

	source .bash_profile

	make sync
	make install

	git checkout .docker
	sudo ./fixup.sh || true
}

main "$@"
