#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export DEBIAN_FRONTEND=noninteractive

	if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi

	source .bash_profile

	make sync
	make install
}

main "$@"
