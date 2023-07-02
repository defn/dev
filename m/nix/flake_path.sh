#!/usr/bin/env bash

set -euo pipefail

function main {
	local dir
	local out

	dir="$1"
	shift

	out="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	cd "${dir}"

	mkdir nix
	rsync -ia --copy-links --exclude nix . nix/.

	cd nix
	git init --quiet
	git add --intent-to-add .

	# shellcheck disable=SC2016
	ln -nfs "$(nix develop --command "$@" || true)" "${out}"
}

main "$@"
