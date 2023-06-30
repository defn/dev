#!/usr/bin/env bash

set -eufo pipefail

set -x

function main {
	local app_config
	local flake_jq
	local flake_go
	local out

	local shome
	shome="$(pwd)"

	app_config="${shome}/$1"
	shift

	flake_jq="${shome}/$1"
	shift

	flake_go="${shome}/$1"
	shift

	out="${shome}/$1"
	shift

	# TODO hacky
	pushd cue.mod/gen
	export HOME="/home/ubuntu"
	export GOMODCACHE="${HOME}/.cache/go-mod"

	for p in $("${flake_jq}" -r '.k8s.apis[]' "${app_config}"); do
		"${flake_go}" get "${p}"
		"${flake-cue}" get go "${p}"
		break
	done

	mkdir -p "${out}/cue.mod/gen"
	rsync -ia cue.mod/gen/k8s.io "${out}/"
}

main "$@"
