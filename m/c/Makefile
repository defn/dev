SHELL := /bin/bash

build:
	$(MAKE) update
	b run outputs_config__update
	b run outputs_kustomize__update
	$(MAKE) make_add_generated

update:
	helm template karpenter --version v0.28.0 --include-crds -f karpenter-values.yaml oci://public.ecr.aws/karpenter/karpenter | tail -n +3 > ../k/karpenter/karpenter.yaml

event:
	k create cm feh-$$(date +%s) --from-file=script=events.sh

make_%:
	./$@.sh
