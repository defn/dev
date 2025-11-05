#!/usr/bin/env bash

# Counts words in input file
function main {
	local input="${in[input]}"
	local out="${shome}/${out}"

	wc -w <"${input}" >"${out}"
}

source b/lib/lib.sh
