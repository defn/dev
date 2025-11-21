#!/usr/bin/env bash

function main {
	{
		echo '@experiment(aliasv2)'
		echo '@experiment(explicitopen)'
		echo ''
		# application: repo: ...
		gh repo list defn --json name,description,url,createdAt | jq 'map({(.name): .}) | add' | cue import -p application -l \"repo\" json: -
	} >gen.cue
}

main "$@"
