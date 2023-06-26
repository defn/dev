SHELL := /bin/bash

build:
	$(MAKE) make_generate_kustomize
	$(MAKE) make_generate_release
	$(MAKE) make_add_generated

update:
	helm template karpenter --version v0.28.0 --include-crds -f karpenter-values.yaml oci://public.ecr.aws/karpenter/karpenter | tail -n +3 > ../k/karpenter/karpenter.yaml

event:
	k create cm feh-$$(date +%s) --from-file=script=events.sh

make_%:
	./$@.sh
