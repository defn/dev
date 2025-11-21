#!/usr/bin/env bash

function main {
	{
		echo '@experiment(aliasv2)'
		echo '@experiment(explicitopen)'
		echo ''
		# execution: resource: NAMESPACE: NAME: ...
		kubectl kustomize . | cue import -p execution -l \"resource\" -l metadata.namespace -l metadata.name yaml: -
	} >gen.cue
}

main "$@"
