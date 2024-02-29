#!/usr/bin/env bash

function main {
	cd
	unset STARSHIP_NO
	source .bash_profile
	setsid code-server --auth none --port 13337 1>>/tmp/stdout.log 2>>/tmp/stderr.log &
}

time main "$@"
