#!/usr/bin/env bash

function main {
	local aws_version
	local aws_config
	local aws_profile

	aws_version="$1"
	shift

	aws_config="$1"
	shift

	aws_profile="$1"
	shift

	exec env AWS_CONFIG="${aws_config}" AWS_PROFILE="${aws_profile}" nix run --quiet --quiet --quiet "github:defn/dev/pkg-awscli-${aws_version}?dir=m/pkg/awscli" -- "$@"
}

main "$@"
