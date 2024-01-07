#!/usr/bin/env bash

function main {
	local cue="${shome}/${in[cue]}"

	set +f
	"${cue}" export --out json -e cached_yaml k/*.cue "$@" \
		| jq -r 'to_entries[] | .value' \
	>"${out}"
}

source b/lib/lib.sh
