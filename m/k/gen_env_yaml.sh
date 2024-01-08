#!/usr/bin/env bash

function main {
	local cue="${shome}/${in[cue]}"

	local cue_import="$1"; shift
	local image_digest="$1"; shift

	local out="$1"; shift

	cat "${cue_import}" | grep -v 'targetRevision: "app-version-not-found"' > cue_import.cue

	cluster="coder-amanibhavam-district"
	name="kyverno"
	version="0.0.2"

	echo "res: application: \"${cluster}-cluster-env\": argocd: \"${cluster}-cluster-${name}\": spec: source: targetRevision: \"${version}\"" > cue_versions.cue

	set +f
	"${cue}" export --out json -e cached_yaml k/*.cue "cue_import.cue" "cue_versions.cue" "${image_digest}" \
		| jq -r 'to_entries[] | .value' \
	>"${out}"
}

source b/lib/lib.sh
