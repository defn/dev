#!/usr/bin/env bash

function main {
	local dir="${in[dir]}"

	local out="${shome}/${out}"

	cd "${dir}"

	mkdir nix
	rsync -ia --copy-links --exclude nix . nix/.

	cd nix
	git init --quiet
	git config user.email "you@example.com"
    git config user.name "Your Name"
	git add .
	git commit -m 'for the build'

	nix build
	local cmd_attic="$(type -P attic ~/bin/nix/attic | head -1)"
	if type -P "${cmd_attic}"; then ("${cmd_attic}" push --ignore-upstream-cache-filter defn result || true); fi

	# shellcheck disable=SC2046
	tar cfz "${out}" $(nix-store --query --requisites --include-outputs result || true)
}

source b/lib/lib.sh
