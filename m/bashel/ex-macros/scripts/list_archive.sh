#!/usr/bin/env bash

# Lists contents of a tarball with metadata
function main {
	local archive="${in[archive]}"
	local out="${shome}/${out}"

	{
		echo "Archive: ${archive}"
		echo "Size: $(stat -c%s "${archive}") bytes"
		echo "Contents:"
		tar tzf "${archive}" | head -20
	} >"${out}"
}

source b/lib/lib.sh
