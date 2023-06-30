#!/usr/bin/env bash

set -eufo pipefail

function main {
	local cue_yaml
	local cue_gen_bin
	local out

	local shome
	shome="$(pwd)"

	cue_yaml="${shome}/$1"
	shift

	cue_gen_bin="${shome}/$1"
	shift

	out="${shome}/$1"
	shift

	# TODO hacky
	cd defn/dev

	"${cue_gen_bin}" -f="${cue_yaml}" --crd=true
	mv crds/customresourcedefinitions.gen.yaml "${out}"
}

main "$@"
