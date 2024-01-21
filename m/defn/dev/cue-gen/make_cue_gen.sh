#!/usr/bin/env bash

set -eufo pipefail

function main {
	local flake_go
	local out

	local shome
	shome="$(pwd)"

	flake_go="${shome}/$1"
	shift

	out="${shome}/$1"
	shift

	# TODO hacky
	cd defn/dev/cue-gen
	export GOMODCACHE="${HOME}/.cache/go-mod"

	go build istio.io/tools/cmd/cue-gen
	chmod 755 cue-gen
	mv cue-gen "${out}"
}

main "$@"
