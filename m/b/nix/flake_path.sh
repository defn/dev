#!/usr/bin/env bash

set -euo pipefail

function main {
	local dir
	local out

	dir="$1"
	shift

	bin_out="$(pwd)/$1"
	shift

	cd "${dir}"

	mkdir nix
	rsync -ia --copy-links --exclude nix . nix/.

	cd nix
	git init --quiet
	git add --intent-to-add .

	# shellcheck disable=SC2016
	nix develop --ignore-environment --command env | grep ^PATH= | cut -d= -f2- >../.path

	cd ..
	mkdir nix_bin
	(for a in $(cat .path | tr : "\n" | perl -e 'print reverse <>'); do for b in "${a}"/*; do if test -x "${b}"; then if [[ "$(readlink "bin/nix/$b{##*/}" || true)" != "${b}" ]]; then ln -nfs "${b}" nix_bin/; fi; fi; done; done)

	cd nix_bin
	ls -ltrhd *
	tar cfz "${bin_out}" .
}

main "$@"
