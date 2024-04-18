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
	cd tmp

	# for each flake, create a directory with nix and bazel paths
	for f in "$@"; do
		mkdir $f
		pushd $f >/dev/null
		tar -xf ../../"${in[${f}_path]}"
		# save the bazel artifact path because the artifact itself is huge
		echo "${in[${f}_store]}" > .bazel-nix-store
		popd >/dev/null
	done

	# create an archive of tmp
	tar cfz ../something.tar.gz .

	# then move archive into output from the sandbox root
	cd ..
	mv something.tar.gz $out
}

source b/lib/lib.sh
