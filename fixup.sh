#!/usr/bin/env bash

set -efu -o pipefail

function main {
	sudo perl -pe 's{^\s*GSSAPIAuthentication}{#GSSAPIAuthentication}' -i /etc/ssh/ssh_config

	if test -x /usr/local/bin/nix/ping; then	
		sudo setcap cap_net_raw+p $(readlink /usr/local/bin/nix/ping)
	fi

	for a in docker-credential-{pass,secretservice}; do rm -vf "$(which "$a")"; done

	if ! test -e .docker/config.json; then
		cp .docker/config.json.example .docker/config.json
	fi

	if test -e /var/run/docker.sock; then
		sudo chgrp ubuntu /var/run/docker.sock
	fi
	sudo usermod -aG docker ubuntu
}

main "$@"
