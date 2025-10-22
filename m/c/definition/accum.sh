#!/usr/bin/env bash

function main {
	{
		echo '@experiment(aliasv2)'
		echo '@experiment(explicitopen)'
		echo ''
		cat repo.yaml | cue import -p definition yaml: -
	} >gen.cue
}

main "$@"
