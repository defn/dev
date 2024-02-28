#!/usr/bin/env bash

function main {
	cd
	source .bash_profile

	set -e

	setsid code-server --auth none --port 13337 1>>/tmp/stdout.log 2>>/tmp/stderr.log &
}

time main "$@"
