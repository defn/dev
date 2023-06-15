#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_earthly

	local earthfile

	local bhome
	bhome="$(pwd)"

	flake_earthly="${bhome}/$1"
	shift

	earthfile="$1"
	shift

	local pth_build
	pth_build="$(mktemp -d -t XXXXXX)"

	cp -v "${earthfile}" "${pth_build}/"

	(
		set +f
		for i in "$@"; do
			if test -d "${i}"; then
				cp -v "${i}"/* "${pth_build}/"
			else
				cp -v "${i}" "${pth_build}/"
			fi
		done
	)

	if [[ $# == 0 ]]; then set -- --push -no-output +build; fi

	cd "${pth_build}"
	"${flake_earthly}" --push +build

	rm -rf "${pth_build}"
}

main "$@"
