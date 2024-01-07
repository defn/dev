#!/usr/bin/env bash

function main {
	local config="${in[config]}"
	local decode="${in[decode]}"

	local tmp="$(pwd)/tmp"
	mkdir -p "${tmp}"
	cat "${config}" |
		jq --arg out "${tmp}" -r '.gen | to_entries[] | .key as $dir | .value | to_entries[] | "\($out)/\($dir)/\(.key) \(.value | @base64)"' |
		"${decode}"

	tar cfz "${out}" -C "${tmp}" .
}

source b/lib/lib.sh
