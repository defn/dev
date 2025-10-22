#!/usr/bin/env bash

# unify.sh - Unify accumulated data into CUE format with schema validation
# Part of ACUTE: Accumulate, Configure, Unify, Transform, Execute
#
# This script handles the Configure and Unify phases:
# 1. Applies CUE schemas from intention/ to validate data (Configure phase)
# 2. Unifies all data sources into single CUE structure (Unify phase)
#
# Prerequisites: Run accumulate.sh first to gather raw data

function main {
	# Unify with schema validation and export
	if cue eval -c >/dev/null; then
		cue export --out yaml | yq 'del(.config.repo.[].updatedAt)' >main.yaml
		git difftool --no-prompt --extcmd='dyff between' main.yaml
	fi
}

main "$@"
