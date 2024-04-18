#!/usr/bin/env bash

function main {
	mkdir tmp

	for f in "$@"; do
		mkdir tmp/$f
		echo xxxxxxxxxxxx $f
		ls -ltrhd "${in[${f}_path]}"
		tar -C tmp/$f -xvf "${in[${f}_path]}"
		echo "${in[${f}_store]}" > tmp/$f/.bazel-nix-store
	done

	find tmp > $out
}

source b/lib/lib.sh
