#!/usr/bin/env bash

function main {
	mkdir gen
	rsync -iaL cue.mod/gen/. gen/.
	rm -rf cue.mod/gen
	mv gen cue.mod/
	(
		set +f
		cue export --out json -e crds k/*.cue "$@" |
			jq -r 'to_entries[] | .value'
	) >"${out}"
}

source b/lib/lib.sh
