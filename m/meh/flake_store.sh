#!/usr/bin/env bash

set -euo pipefail

function main {
	local out

	out="$(pwd)/$1"
	shift

	cd meh

	mkdir nix
	cp flake.* nix/

	cd nix
	git init
	git add .

	nix build
	set -x
	tar cvfz "${out}" "$@"
}

main "$@"
