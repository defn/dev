#!/usr/bin/env bash
#
# Generates an archive of nix bin paths with bazel artifact paths
# Used to quickly determine which bazel artifacts have not been installed by
# intalling flake nix bin paths, stat paths for existence, then look up the bazel
# artifact for the flake.
#

function main {
	# tmp accumulates flake paths
	mkdir tmp

	# for each flake, create a directory with nix and bazel paths
	for f in "$@"; do
		mkdir tmp/$f
		tar xfz "${in[${f}_path]}" -C tmp/$f
		# save the bazel artifact path because the artifact itself is huge
		echo "${in[${f}_store]}" > tmp/$f/.bazel-nix-store
	done

	# create an archive of tmp
	tar cfz $out -C tmp .
}

source b/lib/lib.sh
