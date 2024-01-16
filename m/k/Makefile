SHELL := /bin/bash

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

login:
	helm registry login -u 'robot$$meh' $(registry)

template:
	helm template --insecure-skip-tls-verify $(chart) oci://$(registry)/library/helm/$(chart) --version $(version)

cache:
	cue export --out json -e image_digests | jq -r '.[]' | grep "$(filter)" | runmany 4 2 'proxy=$$2; \
		skopeo copy docker://$${proxy} docker://coder-amanibhavam-district.tail3884f.ts.net:5000/$${2} --multi-arch all --dest-tls-verify=false --insecure-policy'

update:
# ensure no argocd-repo-server pods are in a non-Running state, the cli will pick any pod
	app set $(env)-cluster --repo coder-amanibhavam-district.tail3884f.ts.net:5000 --revision $$(helm show chart --insecure-skip-tls-verify oci://coder-amanibhavam-district.tail3884f.ts.net:5000/library/helm/$(env)-cluster-env 2>/dev/null | grep ^version: | awk '{print $$2}')