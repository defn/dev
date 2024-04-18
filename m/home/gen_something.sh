#!/usr/bin/env bash

function main {
	mkdir tmp
	cd tmp

	for f in "$@"; do
		mkdir $f
		pushd $f >/dev/null
		tar -xf ../../"${in[${f}_path]}"
		echo "${in[${f}_store]}" > .bazel-nix-store
		popd >/dev/null
	done

	tar cfz ../something.tar.gz .
	cd ..
	mv something.tar.gz $out
}

source b/lib/lib.sh
