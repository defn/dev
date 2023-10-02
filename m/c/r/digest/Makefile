list:
	cue export --out json  -e uncached_resources | jq -S > a.json
	cue export --out json  -e cached_resources | jq -S > b.json

diff:
	$(MAKE) list
	diff a.json b.json | grep '^[<>]'

cache:
	cue export --out json -e image_digests | jq -r '.[]' | runmany 4 2 'set -x; skopeo copy docker://$${2} docker://169.254.32.1:5000/$${2} --multi-arch all --dest-tls-verify=false --insecure-policy'