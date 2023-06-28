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
	rsync -ia --copy-links --exclude nix . nix/.

	cd nix
	git init --quiet
	git add --intent-to-add .

	nix build

	# shellcheck disable=SC2046
	tar cf "${out}" $(nix-store --query --requisites --include-outputs result || true)
}

main "$@"
