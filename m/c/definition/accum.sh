#!/usr/bin/env bash

function main {
	{
		echo '@experiment(aliasv2)'
		echo '@experiment(explicitopen)'
		echo ''
		cat repo.yaml | cue import -p definition yaml: -
		cat ../../infra/output/output.json | cue import -l '"terraform"' -l '"output"' json: -
	} >gen.cue
}

main "$@"
