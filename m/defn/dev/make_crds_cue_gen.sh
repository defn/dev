#!/usr/bin/env bash

set -eufo pipefail

function main {
	local cue_yaml
	local cue_gen_bin
	local out

	cue_yaml="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	cue_gen_bin="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	out="${BUILD_WORKING_DIRECTORY}/$1"
	shift

	# TODO hacky
	cd defn/dev

	"${cue_gen_bin}" -f="${cue_yaml}" --crd=true
	mv crds/customresourcedefinitions.gen.yaml "${out}"
}

main "$@"
