SHELL := /bin/bash

build:
	cd lesson && $(MAKE) build

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

	cp images.txt images.txt.1
	this-k3d-list-images dfd | grep -v 169.254.32.1 | sort >> images.txt.1
	cat images.txt.1 | sort -u > images.txt
	rm -f images.txt.1
	git diff images.txt

cache:
	cat images.txt | this-k3d-save-images

helm_add:
	(cd .. && git grep repo: kustomize.cue) | cut -d'"' -f2 | sort -u | while read -r repo; do helm repo add $$(echo $$repo | cut -d/ -f3- | perl -pe 's{\s+$$}{}; s{\W+}{-}g') $$repo; done
	helm repo update
