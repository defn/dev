#!/usr/bin/env bash

function main {
	cd ~/m/pb
	cue export --out=json -e inventory
}

main "$@"
