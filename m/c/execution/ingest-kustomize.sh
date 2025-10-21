#!/usr/bin/env bash

function main {
	kubectl kustomize . | cue import -p e -l \"resource\" -l metadata.namespace -l metadata.name yaml: - >main.cue
}

main "$@"
