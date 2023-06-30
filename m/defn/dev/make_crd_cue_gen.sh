#!/usr/bin/env bash

set -eufo pipefail

function main {
	go mod init meh
	go get istio.io/tools/cmd/cue-gen
	go install istio.io/tools/cmd/cue-gen
	rm go.mod go.sum
	"$(go env GOPATH)/bin/cue-gen" -f=cue.yaml --crd=true
}

main "$@"
