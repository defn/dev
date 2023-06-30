#!/usr/bin/env bash

set -eufo pipefail

function main {
	if ! test -x "$(go env GOPATH || true)/bin/cue-gen"; then
		go mod init meh
		go get istio.io/tools/cmd/cue-gen
		go install istio.io/tools/cmd/cue-gen
		rm go.mod go.sum
	fi

	"$(go env GOPATH || true)/bin/cue-gen" -f=cue.yaml --crd=true
}

main "$@"
