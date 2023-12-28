#!/usr/bin/env bash

function main {
	local dir="${in[dir]}"

	local out="${shome}/${out}"

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
	(set +f; for a in $(cat .path | tr : "\n" | perl -e 'print reverse <>'); do for b in "${a}"/*; do if test -x "${b}"; then if [[ "$(readlink "bin/nix/$b{##*/}" || true)" != "${b}" ]]; then ln -nfs "${b}" nix_bin/; fi; fi; done; done)

	cd nix_bin
	tar cfz "${out}" .
}

source b/lib/lib.sh
