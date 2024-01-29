#!/usr/bin/env bash

function main {
	local app="${in[app]}"
	local cue="${in[cue]}"

	(
		set +f
		echo package k
		"${cue}" export --out json -e images "${app}" k/*.cue | jq -r '.[]' |
			sort -u |
			runmany 8 'echo cache: \"$1\": \"$(echo $1 | perl -pe '"'"'s{[:@].*$}{}'"'"')@$(skopeo inspect docker://${1%%@sha256*} | jq -r .Digest)\"' |
			while read -r l; do
				echo "$l"
			done
	) >image_digest.cue

	cat image_digest.cue

	if grep '@"$' image_digest.cue; then
		echo "ERROR: digest not found" 1>&2
		return 1
	fi

	mv image_digest.cue "${out}"
}

source b/lib/lib.sh
