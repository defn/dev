#!/usr/bin/env bash

# Converts input file to uppercase
function main {
	local input="${in[input]}"
	local out="${shome}/${out}"

	tr '[:lower:]' '[:upper:]' <"${input}" >"${out}"
}

source b/lib/lib.sh
