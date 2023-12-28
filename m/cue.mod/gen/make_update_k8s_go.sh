#!/usr/bin/env bash

set -eufo pipefail

function main {
	# shellcheck disable=SC2016
	b out app | jq -r '.k8s.apis[]' | runmany 'mark $1; go get -u $1'
}

main "$@"
