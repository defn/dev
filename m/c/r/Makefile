images:
	cue export --out json -e images | jq -r '.[]' | sort

.PHONY: digest
digest:
	(echo package r; cue export --out json -e images | jq -r '.[]' | sort -u | runmany 8 'echo cache: \"$$1\": \"$$(echo $$1 | perl -pe 's{[:@].*$$}{}')@$$(skopeo inspect docker://$${1%%@sha256*} | jq -r '.Digest')\"' | sort | while read -r l; do echo; echo "$$l"; done) > digest/digest_gen.cue
