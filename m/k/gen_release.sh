#!/usr/bin/env bash

set -euo pipefail

function main {
	local app
	local out

	app="$1"
	shift
	out="$1"
	shift

	if test -e "k/${app}/kustomization.yaml"; then
		rm -rf "k/${app}/chart"
		kustomize build --load-restrictor LoadRestrictionsNone --enable-helm "k/${app}" >"${out}"
	else
		touch "${out}"
	fi
}

main "$@"
