#!/usr/bin/env bash

set -eufo pipefail

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
	local dst="cue.mod/gen"
	local desired="k8s.io"

	pushd "${dst}"
	export GOMODCACHE="${HOME}/.cache/go-mod"

	for p in $("${flake_jq}" -r '.k8s.apis[]' "${app_config}"); do
		"${flake_go}" get "${p}"
		"${flake-cue}" get go "${p}"
	done

	mkdir -p "${out}/${dst}"
	rsync -ia "${dst}/${desired}" "${out}/${dst}/"
}

main "$@"
