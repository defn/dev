#!/usr/bin/env bash

# accumulate.sh - Accumulate raw data from multiple sources
# Part of ACUTE: Accumulate, Configure, Unify, Transform, Execute
#
# This script gathers raw data from various sources by calling accum.sh
# in each subdirectory. Each accum.sh script collects data and generates
# CUE files without validation.

function main {
	# Accumulate raw data from various sources
	(cd definition && ./accum.sh)
	(cd execution && ./accum.sh)
	(cd application && ./accum.sh)
}

main "$@"
