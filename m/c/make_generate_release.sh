#!/usr/bin/env bash

set -eufo pipefail

function main {
	# shellcheck disable=SC2016
	runmany 4 '
		echo $1
		(
			set -eufo pipefail
			cd $1
			echo
			pwd
			rm -rf charts local
			mkdir -p ../../r/$(basename $1)
			kustomize build --enable-helm > ../../r/$(basename $1)/main.yaml
			rm -rf charts local
		) || (echo "ERROR: $1" && true)
	' < <(
		set +f
		ls -d ../k/*/ || true
	)
}

main "$@"
