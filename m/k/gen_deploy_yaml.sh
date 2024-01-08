#!/usr/bin/env bash

function main {
	local cue="${shome}/${in[cue]}"

	local cue_import="$1"; shift
	local image_digest="$1"; shift

	local out="$1"; shift

	set +f
	"${cue}" export --out json -e cached_yaml k/*.cue "${cue_import}" "${image_digest}" \
		| jq -r 'to_entries[] | .value' \
	>"${out}"
}

source b/lib/lib.sh
