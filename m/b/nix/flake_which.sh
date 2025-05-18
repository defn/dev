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
	ln -nfs "$(nix develop --command "$@" || true)" "${out}"
}

source b/lib/lib.sh
