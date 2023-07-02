#!/usr/bin/env bash

set -eufo pipefail

function main {
	local flake_go
	local out

	flake_go="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	out="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	# TODO hacky
	cd defn/dev/cue-gen
	export GOMODCACHE="${HOME}/.cache/go-mod"

	"${flake_go}" build istio.io/tools/cmd/cue-gen
	chmod 755 cue-gen
	mv cue-gen "${out}"
}

main "$@"
