#!/usr/bin/env bash

set -euo pipefail

function main {
	local release_py
	local app
	local out

	release_py="$1"
	shift
	app="$1"
	shift
	out="$1"
	shift

	local tmp="$(pwd)/tmp"
	mkdir -p "${tmp}"
	cat "${app}" | jq --arg out "${tmp}" -r '.gen | to_entries[] | .key as $dir | .value | to_entries[] | "\($out)/\($dir)/\(.key) \(.value | @base64) 0"' | $release_py
	(cd "${tmp}" && tar cvfz - .) > "${out}"

}

main "$@"
