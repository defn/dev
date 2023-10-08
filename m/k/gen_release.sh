#!/usr/bin/env bash

set -euo pipefail

function main {
	local app
	local out

	app="$1"
	shift
	out="$1"
	shift

	if test -e "${app}/kustomization.yaml"; then
		kustomize build --enable-helm "${app}" >"${out}"
		rm -rf "${app}/charts"
	else
		touch "${out}"
	fi
}

main "$@"
