#!/usr/bin/env bash

function main {
	local config="${in[config]}"
	local decode="${in[decode]}"
	local prefix="${in[prefix]}"

	local tmp="$(pwd)/tmp"
	mkdir -p "${tmp}"
	cat "${config}" |
		jq --arg out "${tmp}" --arg prefix "${prefix}" -r \
			'.gen | to_entries[] | .key as $dir | .value | with_entries(select(.key | startswith($prefix))) | to_entries[] | "\($out)/\($dir)/\(.key) \(.value | @base64)"' |
		"${decode}"

	tar cfz "${out}" --numeric-owner --mtime='1970-01-01 00:00:00' -C "${tmp}" .
}

source b/lib/lib.sh
