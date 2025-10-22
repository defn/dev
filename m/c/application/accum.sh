#!/usr/bin/env bash

function main {
	gh repo list defn --json name,description,url,createdAt | jq 'map({(.name): .}) | add' | cue import -p application -l \"repo\" json: - >gen.cue
	cue fmt
}

main "$@"
