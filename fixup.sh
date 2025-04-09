#!/usr/bin/env bash

set -efu -o pipefail

function main {
	if text -x ~/.local/bin/mise; then
		~/.local/bin/mise run local fixup
	fi
}

main "$@"
