#!/usr/bin/env bash

function main {
	cat repo.yaml | cue import -p definition yaml: - >gen.cue
	cue fmt
}

main "$@"
