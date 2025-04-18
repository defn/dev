#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	mkdir gen
	rsync -iaL cue.mod/gen/. gen/.
	rm -rf cue.mod/gen
	mv gen cue.mod/

	(
		set +f
		echo package k
		cue export --out json -e images "${app}" k/*.cue | jq -r '.[]' |
			sort -u |
			runmany 8 'echo cache: \"$1\": \"$(echo $1 | perl -pe '"'"'s{[:@].*$}{}'"'"')@$(echo TODO || skopeo inspect docker://${1%%@sha256*} | jq -r .Digest)\"' |
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
