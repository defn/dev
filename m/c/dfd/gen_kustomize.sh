#!/usr/bin/env bash

set -euo pipefail

function main {
	local app
	local out

	app="$1"
	shift
	out="$1"
	shift

	jq -r '.gen | to_entries[] | .key as $dir | .value | to_entries[] | "\($dir)/\(.key) \(.value | @base64)"' <"${app}" | while read -r fname content; do
		mkdir -p "${out}/${fname%/*}"
		echo "${content}" | base64 -d >"${out}/${fname}"
	done
}

main "$@"
