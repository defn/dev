#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	(set +f; cue export --out json -e cached_yaml k/*.cue "${app}") | jq -r 'to_entries[] | .value' >"${out}"
}

source b/lib/lib.sh
