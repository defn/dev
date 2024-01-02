digest:
	(echo package r; cue export --out json -e images | jq -r '.[]' | sort -u | runmany 8 'echo cache: \"$$1\": \"$$(echo $$1 | perl -pe 's{[:@].*$$}{}')@$$(skopeo inspect docker://$${1%%@sha256*} | jq -r '.Digest')\"' | sort | while read -r l; do echo; echo "$$l"; done) > digest_gen.cue

cache:
	cue export --out json -e image_digests | jq -r '.[]' | grep "$(filter)" | runmany 4 2 'proxy=$$2; \
		skopeo copy docker://$${proxy} docker://cache.defn.run:5000/$${2} --multi-arch all --dest-tls-verify=false --insecure-policy'