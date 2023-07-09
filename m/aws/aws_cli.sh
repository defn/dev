#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_awscli
	local flake_awsvault
	local aws_config
	local aws_profile
	local mode

	local shome
	shome="$(pwd)"

	flake_awscli="${shome}/$1"
	shift

	flake_awsvault="${shome}/$1"
	shift

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
		exec "${flake_awscli}" "$@"
		;;
	aws-vault)
		exec "${flake_awsvault}" "$@"
		;;
	*)
		echo "ERROR: unknown mode ${mode}"
		;;
	esac
}

main "$@"
