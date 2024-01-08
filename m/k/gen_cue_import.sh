#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	(
		cue import "${app}" -p k --with-context \
			-l '"res"' -l 'strings.ToLower(data.kind)' \
			-l "\"$(basename ${app} -kustomized-build.yaml)\"" \
			-l 'strings.ToLower(*data.metadata.namespace | "cluster")' \
			-l data.metadata.name --outfile - |
			perl -pe 's{^\s*\w+:\s+null\s*}{}'
	) >"${out}"
}

source b/lib/lib.sh
