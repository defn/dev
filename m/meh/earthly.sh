#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_earthly
	local earthfile
	local app_config
	local aws_config

	local bhome
	bhome="$(pwd)"

	flake_earthly="${bhome}/$1"
	shift

	earthfile="$1"
	shift

	app_config="$1"
	shift

	aws_config="$1"
	shift

	nix_archives="$1"
	shift

	local pth_build
	pth_build="$(mktemp -d -t XXXXXX)"
	cp -v "${earthfile}" "${app_config}" "${aws_config}" "${pth_build}/"
	(
		set +f
		cp -v "${nix_archives}"/* "${pth_build}/"
	)

	if [[ $# == 0 ]]; then set -- --push -no-output +build; fi

	cd "${pth_build}"
	"${flake_earthly}" "$@"

	rm -rf "${pth_build}"
}

main "$@"
