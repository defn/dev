#!/usr/bin/env bash

function main {
	local dir="${in[dir]}"

	local out="${shome}/${out}"

	cd "${dir}"

	mkdir nix
	rsync -ia --copy-links --exclude nix . nix/.

	cd nix
	git init --quiet
	git add .
	git config --global user.email "you@example.com"
    git config --global user.name "Your Name"

	nix build
	if type -P attic; then (attic push --ignore-upstream-cache-filter defn result || true); fi

	# shellcheck disable=SC2046
	tar cfz "${out}" $(nix-store --query --requisites --include-outputs result || true)
}

source b/lib/lib.sh
