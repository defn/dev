#!/usr/bin/env bash

# bump: 8

function main {
	local registry="${in[registry]}"

	local cue="${shome}/${in[cue]}"
	local skopeo="${in[registry]}"

	local cue_import="$1"
	shift
	local image_digest="$1"
	shift
	local out="$1"
	shift

	set +f

	mkdir gen
	rsync -iaL cue.mod/gen/. gen/.
	rm -rf cue.mod/gen
	mv gen cue.mod/

	if false; then
		"${cue}" export --out json -e image_digests "${cue_import}" "${image_digest}" k/*.cue |
			jq -r '.[]' |
			while read -r image_original image_digested; do
				if [[ "$(${skopeo} inspect --tls-verify=false "docker://${registry}/${image_digested}" | jq -r .Digest)" != "${image_digested##*@}" ]]; then
					echo "caching ${image_digested} to docker://${registry}/${image_digested%%@*}"
					${skopeo} copy docker://${image_digested} docker://${registry}/${image_digested%%@*} --multi-arch all --dest-tls-verify=false --insecure-policy
				else
					echo "already cached ${image_digested} to docker://${registry}/${image_digested%%@*}"
				fi
			done
	fi

	"${cue}" export --out json -e cached_yaml "${cue_import}" "${image_digest}" k/*.cue |
		jq -r 'to_entries[] | .value' \
			>"${out}"
}

source b/lib/lib.sh
