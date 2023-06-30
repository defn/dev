#!/usr/bin/env bash

set -eufo pipefail

function main {
	if ! test -x ./cue-gen/go/bin/cue-gen; then
		pushd cue-gen
		GOPATH="$(pwd)/go"
		export GOPATH
		go install istio.io/tools/cmd/cue-gen
		popd
	fi

	./cue-gen/go/bin/cue-gen -f=cue.yaml --crd=true
}

main "$@"
