#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	 dot -Tpng < "${app}" > "${out}"
}

source b/lib/lib.sh
