SHELL := /bin/bash

build:
	cd lesson && $(MAKE) build

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

helm_add:
	(cd .. && git grep repo: kustomize.cue) | cut -d'"' -f2 | sort -u | while read -r repo; do helm repo add $$(echo $$repo | cut -d/ -f3- | perl -pe 's{\s+$$}{}; s{\W+}{-}g') $$repo; done
	helm repo update

release:
# make one big cue config
	rm -f ../k/y/cluster.cue
	(echo package y; for r in ../k/y/*/main.yaml; do echo $$r 1>&2; (cue import $$r -p r --with-context -l '"res"' -l 'strings.ToLower(data.kind)' -l 'path.Dir(path.Rel("$(shell cd ../k/y && pwd)",filename))' -l 'strings.ToLower(*data.metadata.namespace | "cluster")' -l data.metadata.name --outfile - \
		| grep -v '^package '); done) > ../k/y/cluster.cue
	perl -pe 's{^\s*\w+:\s+null\s*}{}; s{data: null,}{}' -i ../k/y/cluster.cue
	git add ../k/y
# generate k/r
	rm -rf ../k/r
	cd ./r && $(MAKE) digest
	cd ./r/digest && $(MAKE) release
	rm -rf ../k/r/y
	git add ../k/r