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
	git init --quiet
	git add .
	# shellcheck disable=SC2016
	ln -nfs "$(nix develop --command "$@" || true)" "${out}"
}

main "$@"
