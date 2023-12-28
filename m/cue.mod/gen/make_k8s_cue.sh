#!/usr/bin/env bash

function main {
	local config="${shome}/${in[config]}"
	local jq="${shome}/${in[jq]}"
	local cue="${shome}/${in[cue]}"
	local go="${shome}/${in[go]}"
	local out="${shome}/${out}"

	# TODO how to guess the workarea, cue.mod/gen
	local workarea="cue.mod/gen"
	local ns="k8s.io"

	cd "${workarea}"

	export GOMODCACHE="${HOME}/.cache/go-mod"

	for pkg in $("${jq}" -r '.k8s.apis[]' "${config}"); do
		# TODO figure out how to use ${go}
		"go" get "${pkg}"
		"${cue}" get go "${pkg}"
	done

	tar cvfz - -C "${workarea}" "${ns}" > "${out}"
}

source b/lib/lib.sh
