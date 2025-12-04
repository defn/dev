#!/usr/bin/env bash

# execute.sh - Execute tools to generate final outputs
# Part of ACUTE: Accumulate, Configure, Unify, Transform, Execute
#
# This script runs the Execute phase by building the documentation site
# and other tools that consume transformed data.

function main {
	# Build documentation site from transformed YAML
	cd ..
	turbo build
}

main "$@"
