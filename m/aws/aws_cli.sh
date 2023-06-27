#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_awscli
	local flake_awsvault
	local aws_config
	local aws_profile
	local mode

	flake_awscli="$1"
	shift

	flake_awsvault="$1"
	shift

	aws_config="$1"
	shift

	aws_profile="$1"
	shift

	mode="$1"
	shift

	case "${mode}" in
	aws)
		exec env AWS_CONFIG="${aws_config}" AWS_PROFILE="${aws_profile}" "${flake_awscli}" "$@"
		;;
	aws-vault)
		exec env AWS_CONFIG="${aws_config}" AWS_PROFILE="${aws_profile}" "${flake_awsvault}" "$@"
		;;
	*)
		echo "ERROR: unknown mode ${mode}"
		;;
	esac
}

main "$@"
