#!/usr/bin/env bash

set -efu -o pipefail

function main {
	if test -x ~/.local/bin/mise; then
		~/.local/bin/mise run local fixup
	fi
}

main "$@"
