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
	git add --intent-to-add .

	nix build

	cp "$(nix-store --query --requisites --include-outputs result | grep bash-interactive | head -1 || true)/bin/bash" bash

	# shellcheck disable=SC2046
	tar cvf "${out}" bash $(nix-store --query --requisites --include-outputs result || true)
}

main "$@"
