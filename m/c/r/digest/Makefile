list:
	cue export --out json  -e uncached_resources | jq -S > a.json
	cue export --out json  -e cached_resources | jq -S > b.json

diff:
	$(MAKE) list
	diff a.json b.json | grep '^[<>]'

cache:
	(cue export --out json -e image_digests | jq -r '.[]' | awk '{print $$2}') | this-k3d-save-images