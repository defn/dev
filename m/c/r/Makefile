cache:
	cue export --out json -e image_digests | jq -r '.[]' | grep "$(filter)" | runmany 4 2 'proxy=$$2; \
		skopeo copy docker://$${proxy} docker://cache.defn.run:5000/$${2} --multi-arch all --dest-tls-verify=false --insecure-policy'