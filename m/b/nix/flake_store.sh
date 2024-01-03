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

	set -x

	nix build
	local cmd_attic="$(set +f; type -P attic ~/bin/nix/attic /nix/store/*attic*/bin/attic | head -1)"
	if type -P "${cmd_attic}"; then ("${cmd_attic}" push --ignore-upstream-cache-filter defn2 result || true); fi

	# shellcheck disable=SC2046
	tar cfz "${out}" $(nix-store --query --requisites --include-outputs result || true)
}

source b/lib/lib.sh
