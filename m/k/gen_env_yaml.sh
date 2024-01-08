#!/usr/bin/env bash

function main {
	local cue="${shome}/${in[cue]}"

	local cue_import="$1"; shift
	local image_digest="$1"; shift

	local out="$1"; shift

	cat "${cue_import}" | grep -v 'targetRevision: "app-version-not-found"' > cue_import.cue
	touch cue_versions.cue

	for h in "$@"; do
		mkdir chart
		tar xfz "${h}" -C chart

		local cluster=$(set +f; grep ^name: chart/*/Chart.yaml | awk '{print $2}' | cut -d- -f1-3)
		local name=$(set +f; grep ^name: chart/*/Chart.yaml | awk '{print $2}' | cut -d- -f5-)
		local version=$(set +f; grep ^version: chart/*/Chart.yaml | awk '{print $2}')

		echo "res: application: \"${cluster}-cluster-env\": argocd: \"${cluster}-cluster-${name}\": spec: source: targetRevision: \"${version}\"" >> cue_versions.cue

		rm -rf chart
	done

	set +f
	"${cue}" export --out json -e cached_yaml k/*.cue "cue_import.cue" "cue_versions.cue" "${image_digest}" \
		| jq -r 'to_entries[] | .value' \
	>"${out}"
}

source b/lib/lib.sh
