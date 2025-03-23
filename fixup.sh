#!/usr/bin/env bash

set -efu -o pipefail

function main {
	sudo perl -pe 's{^\s*GSSAPIAuthentication}{#GSSAPIAuthentication}' -i /etc/ssh/ssh_config

	sudo setcap cap_net_raw+p $(readlink $(which ping))

	for a in docker-credential-{pass,secretservice}; do rm -vf "$(which "$a")"; done

	if ! test -e .docker/config.json; then
		cp .docker/config.json.example .docker/config.json
	fi

	sudo chgrp ubuntu /var/run/docker.sock
	sudo usermod -aG docker ubuntu
}

main "$@"
