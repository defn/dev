SHELL := /bin/bash

build:
	helm template karpenter --namespace default --version v0.28.1 --include-crds -f karpenter-values.yaml oci://public.ecr.aws/karpenter/karpenter | tail -n +3 > ../k/karpenter/karpenter.yaml
	b run outputs_kustomize__update
	b pass run //k:outputs_release__update
	$(MAKE) make_add_generated

event:
	k create cm feh-$$(date +%s) --from-file=script=events.sh

pending:
	@git grep artifacthub | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort

make_%:
	./$@.sh