#!/usr/bin/env bash

# unify.sh - Unify accumulated data into CUE format with schema validation
# Part of ACUTE: Accumulate, Configure, Unify, Transform, Execute
#
# This script:
# 1. Calls accum.sh in each subdirectory to gather raw data (Accumulate phase)
# 2. Applies CUE schemas from intention/ to validate data (Configure phase)
# 3. Unifies all data sources into single CUE structure (Unify phase)

function main {
	# Accumulate raw data from various sources
	(cd definition && ./accum.sh)
	(cd execution && ./accum.sh)
	(cd application && ./accum.sh)

	# Unify with schema validation and export
	if cue eval -c >/dev/null; then
		cue export --out yaml | yq 'del(.config.repo.[].updatedAt)' >main.yaml
		git difftool --no-prompt --extcmd='dyff between' main.yaml
	fi
}

main "$@"
