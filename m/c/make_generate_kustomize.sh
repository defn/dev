#!/usr/bin/env bash

set -eufo pipefail

function main {
	cue cmd gen
}

main "$@"
