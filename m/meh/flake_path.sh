#!/usr/bin/env bash

set -euo pipefail

set -x

function main {
	cd meh

	mkdir nix
	cp flake.* nix/
	cd nix
	git init
	git add .
	# shellcheck disable=SC2016
	nix develop --command bash -c 'echo $PATH' '>' ../meh.txt
}

main "$@"
