#!/usr/bin/env bash

set -eufo pipefail

function main {
	# shellcheck disable=SC2016
	jq -r '.k8s.apis[]' | runmany 'mark $1; go get $1; cue get go $1'
}

main "$@"
