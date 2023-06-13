#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_earthly
	local earthfile
	local app_config
	local aws_config

	flake_earthly="$(pwd)/$1"
	shift

	# shellcheck disable=SC2034
	earthfile="$1"
	shift

	# shellcheck disable=SC2034
	app_config="$1"
	shift

	# shellcheck disable=SC2034
	aws_config="$1"
	shift

	local pth_build
	pth_build="$(mktemp -d -t XXXXXX)"
	cp "${earthfile}" "${app_config}" "${aws_config}" "${pth_build}/"

	cd "${pth_build}"
	"${flake_earthly}" "$@"

	rm -rf "${pth_build}"
}

main "$@"
