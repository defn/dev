#!/usr/bin/env bash

set -efu -o pipefail

function main {
	mise run local fixup
}

main "$@"
