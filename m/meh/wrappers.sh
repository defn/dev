#!/usr/bin/env bash

set -efuo pipefail

function main {
	# shellcheck disable=SC2016
	awk '/^[a-z]/ {print $1 "-" $2}' aws_accounts.txt | runmany 4 'bazel run --script_path=bin/$1 //meh:aws_cli $1'
}

main "$@"
