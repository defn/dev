#!/usr/bin/env bash

function main {
	local cue="${shome}/${in[cue]}"

	local cue_import="$1"; shift
	local image_digest="$1"; shift
	local out="$1"; shift

	set +f

	"${cue}" export --out json -e image_digests "${cue_import}" "${image_digest}" k/*.cue \
		| jq -r '.[]' \
		| runmany 4 2 'proxy=$2; skopeo copy docker://${proxy} docker://cache.defn.run:5000/${2} --multi-arch all --dest-tls-verify=false --insecure-policy'

	"${cue}" export --out json -e cached_yaml "${cue_import}" "${image_digest}" k/*.cue \
		| jq -r 'to_entries[] | .value' \
		>"${out}"
}

source b/lib/lib.sh
