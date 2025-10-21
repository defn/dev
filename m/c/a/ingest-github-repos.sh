#!/usr/bin/env bash

function main {
	gh repo list defn --json name,description,url,createdAt,updatedAt | jq 'map({(.name): .}) | add' | cue import -p a -l \"repo\" json: - >main.cue
}

main "$@"
