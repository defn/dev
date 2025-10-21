#!/usr/bin/env bash

function main {
	kubectl kustomize . | cue import -p main -l \"resources\" -l metadata.namespace -l metadata.name yaml: - >main.cue
}

main "$@"
