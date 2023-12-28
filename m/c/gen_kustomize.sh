#!/usr/bin/env bash

function main {
	local release="${in[release]}"
	local config="${in[config]}"

	local tmp="$(pwd)/tmp"
	mkdir -p "${tmp}"
	cat "${config}" | jq --arg out "${tmp}" -r '.gen | to_entries[] | .key as $dir | .value | to_entries[] | "\($out)/\($dir)/\(.key) \(.value | @base64) 0"' \
		| $release
	(cd "${tmp}" && tar cvfz - .) > "${out}"

}

source b/lib/lib.sh
