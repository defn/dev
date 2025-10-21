#!/usr/bin/env bash

function main {
	kubectl kustomize . | cue import -p execution -l \"resource\" -l metadata.namespace -l metadata.name yaml: - >gen.cue
	cue fmt
}

main "$@"
