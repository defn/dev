#!/usr/bin/env bash

set -euo pipefail

function main {
	local dir
	local out

	dir="$1"
	shift

	out="$(pwd)/$1"
	shift

	cd "${dir}"

	mkdir nix
	cp flake.* nix/

	cd nix
	git init --quiet
	git add .

	nix build
	set -x
	mkdir -p "${out}"
	for a in $(nix-store --query --requisites --include-outputs result); do
		tar cvfz "${out}/${a##*/}.tar.gz" "${a}"
	done
}

main "$@"
