#!/usr/bin/env bash

set -eufo pipefail

function main {
	go get istio.io/tools/cmd/cue-gen
	go install istio.io/tools/cmd/cue-gen
	git checkout ../go.mod ../go.sum
	"$(go env GOPATH)/bin/cue-gen" -f=cue.yaml --crd=true
}

main "$@"
