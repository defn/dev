images:
	cue export --out json -e images | jq -r '.[]' | sort

digest:
	(echo package r; cue export --out json -e images | jq -r '.[]' | runmany 8 'echo cache: \"$$1\": \"$$(echo $$1 | perl -pe 's{[:@].*$$}{}')@$$(skopeo inspect docker://$${1%%@sha256*} | jq -r '.Digest')\"' | sort) > digest.cue
