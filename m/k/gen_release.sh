#!/usr/bin/env bash

set -euo pipefail

function main {
	local app
	local out

	app="$1"
	shift
	out="$1"
	shift

	kustomize build --enable-helm "${app}" >"${out}"
}

main "$@"
