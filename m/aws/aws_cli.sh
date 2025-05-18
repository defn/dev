#!/usr/bin/env bash

set -efuo pipefail

function main {
	local aws_config
	local aws_profile
	local mode

	local shome
	shome="$(pwd)"

	aws_config="${shome}/$1"
	shift

	aws_profile="$1"
	shift

	mode="$1"
	shift

	cd "${BUILD_WORKING_DIRECTORY}"

	export AWS_CONFIG_FILE="${aws_config}" AWS_PROFILE="${aws_profile}"

	case "${mode}" in
	aws)
		exec aws "$@"
		;;
	aws-vault)
		exec aws-vault "$@"
		;;
	*)
		echo "ERROR: unknown mode ${mode}"
		;;
	esac
}

main "$@"
