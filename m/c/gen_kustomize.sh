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

	jq --arg out "${out}" -r '.gen | to_entries[] | .key as $dir | .value | to_entries[] | "\($out)/\($dir)/\(.key) \(.value | @base64) 0"' <"${app}" | $release_py
}

main "$@"
