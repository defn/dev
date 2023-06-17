SHELL := /bin/bash

build:
	$(MAKE) make_clean_generated
	$(MAKE) make_generate_kustomize
	$(MAKE) make_generate_release
	$(MAKE) make_add_generated

update:
	helm template karpenter --version v0.18.1 --include-crds -f values.yaml oci://public.ecr.aws/karpenter/karpenter | tail -n +3 > ../k/karpenter/karpenter.yaml

event:
	k create cm feh-$$(date +%s) --from-file=script=events.sh

make_%:
	./$@.sh