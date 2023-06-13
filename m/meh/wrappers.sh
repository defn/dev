#!/usr/bin/env bash

set -efuo pipefail

function main {
	# shellcheck disable=SC2016
	grep profile ~/.aws/config | awk '/sso-source/ {print $2}' | cut -d- -f1-2 | grep -v sso | runmany 4 'bazel run --script_path=bin/$1 //meh:aws_cli $1'
}

main "$@"
