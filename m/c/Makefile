SHELL := /bin/bash

build:
# helm generates ./k/karpenter/karpenter.yaml
	b run outputs_karpenter__update
# cue ./c/ generates kustomize ./k/
	b run outputs_kustomize__update
# kustomize ./k/ generates ./k/r/ release yaml
	(cd ../k && b run outputs_release__update)
# add generated to git
	$(MAKE) make_add_generated

event:
	k create cm feh-$$(date +%s) --from-file=script=events.sh

pending:
	@git grep artifacthub | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort

make_%:
	./$@.sh