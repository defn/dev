#!/usr/bin/env bash

set -efu -o pipefail

function main {
	sudo perl -pe 's{^\s*GSSAPIAuthentication}{#GSSAPIAuthentication}' -i /etc/ssh/ssh_config
}

main "$@"
