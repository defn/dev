#!/usr/bin/env bash

function main {
	local config
	local aws_config
	local aws_profile

	config="$1"
	shift

	aws_config="$1"
	shift

	aws_profile="$1"
	shift

	local aws_version
	aws_version="$(jq -r .version.aws <"${config}")"

	exec env AWS_CONFIG="${aws_config}" AWS_PROFILE="${aws_profile}" nix run --quiet --quiet --quiet "github:defn/dev/pkg-awscli-${aws_version}?dir=m/pkg/awscli" -- "$@"
}

main "$@"
