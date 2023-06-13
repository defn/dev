#!/usr/bin/env bash

set -efuo pipefail

function main {
	local flake_aws
	local app_config
	local aws_config
	local aws_profile

	flake_aws="$1"
	shift

	# shellcheck disable=SC2034
	app_config="$1"
	shift

	aws_config="$1"
	shift

	aws_profile="$1"
	shift

	exec env AWS_CONFIG="${aws_config}" AWS_PROFILE="${aws_profile}" "${flake_aws}" "$@"
}

main "$@"
