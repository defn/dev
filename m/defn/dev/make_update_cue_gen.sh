#!/usr/bin/env bash

set -eufo pipefail

function main {
	go get -u istio.io/tools/cmd/cue-gen
}

main "$@"
