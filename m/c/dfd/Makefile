SHELL := /bin/bash

build:
# remove everything
	rm -rf ../../k/*/
# helm generates ./k/karpenter/karpenter.yaml
#	b run outputs_karpenter__update
# cue ./c/ generates kustomize ./k/
	b run outputs_kustomize__update
# kustomize ./k/ generates ./k/r/ release yaml
	(cd ../../k && b run outputs_release__update)
# add generated to git
	../make_add_generated.sh
