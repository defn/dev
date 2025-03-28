#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export SUDO_USER="${SUDO_USER:-1000}"

	perl -pe 's{^\s*GSSAPIAuthentication}{#GSSAPIAuthentication}' -i /etc/ssh/ssh_config

	if test -x /usr/local/bin/nix/ping; then
		setcap cap_net_raw+p $(readlink /usr/local/bin/nix/ping)
	fi

	for a in docker-credential-{pass,secretservice}; do rm -vf "$(which "$a")"; done

	if ! test -e .docker/config.json; then
		install -o "$(id -un $SUDO_USER)" -g "$(id -gn $SUDO_USER)" -m 0600 .docker/config.json.example .docker/config.json
	fi

	if test -e /var/run/docker.sock; then
		chgrp "$(id -gn $SUDO_USER)" /var/run/docker.sock
	fi
	usermod -aG docker "$(id -un $SUDO_USER)"
}

main "$@"
