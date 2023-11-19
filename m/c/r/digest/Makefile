list:
	cue export --out json  -e uncached_resources | jq -S > a.json
	cue export --out json  -e cached_resources | jq -S > b.json

diff:
	diff a.json b.json | grep '^[<>]'

vimdiff:
	vimdiff a.json b.json

cache:
	cue export --out json -e image_digests | jq -r '.[]' | runmany 4 2 'proxy=$$2; \
		case $$2 in \
			*) true ;; \
			docker.io*) proxy=harbor.district.amanibhavam.defn.run/docker/$${2#docker.io/} ;; \
			quay.io*) proxy=harbor.district.amanibhavam.defn.run/quay/$${2#quay.io/} ;; \
			gcr.io*) proxy=harbor.district.amanibhavam.defn.run/gcr/$${2#gcr.io/} ;; \
			ghcr.io*) proxy=harbor.district.amanibhavam.defn.run/ghcr/$${2#ghcr.io/} ;; \
			public.ecr.aws*) proxy=harbor.district.amanibhavam.defn.run/ecr/$${2#public.ecr.aws/} ;; \
			registry.k8s.io*) proxy=harbor.district.amanibhavam.defn.run/k8s/$${2#registry.k8s.io/} ;; \
			registry.opensource.zalan.do*) proxy=harbor.district.amanibhavam.defn.run/zalando/$${2#registry.opensource.zalan.do/} ;; \
			*.*) true ;; \
			*) proxy=harbor.district.amanibhavam.defn.run/docker/$$2 ;; \
		esac; \
		skopeo copy docker://$${proxy} docker://169.254.32.1:5000/$${2} --multi-arch all --dest-tls-verify=false --insecure-policy'

release:
	cue export --out json -e cached_yaml | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' \
		| while read -r fname data; do \
			mkdir -p ../../../k/r/$$(dirname $$fname); \
			echo "$$data" | base64 -d | sed 's#{{#{{ "{{" }}#g' > ../../../k/r/$$fname; \
		done
