#!/usr/bin/env bash

set -eufo pipefail

function main {
	git add -u ../e ../k && git add ../e ../k
	git add -u ../r && git add ../r
}

main "$@"
