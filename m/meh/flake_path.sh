#!/usr/bin/env bash

set -euo pipefail

set -x

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
	# shellcheck disable=SC2016
	nix develop --command "$@" >"${out}"
}

main "$@"
