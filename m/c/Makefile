SHELL := /bin/bash

build:
	cd lesson && $(MAKE) build

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

helm_add:
	(cd .. && git grep repo: kustomize.cue) | cut -d'"' -f2 | sort -u | while read -r repo; do helm repo add $$(echo $$repo | cut -d/ -f3- | perl -pe 's{\s+$$}{}; s{\W+}{-}g') $$repo; done
	helm repo update

release-all:
	for a in coder-*/; do (cd $$a && make); done
	$(MAKE) release

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

once:
	mkdir -p ./$(shell uname -n)/openid
	tailscale funnel 443 on
	tailscale serve https /openid $(shell pwd)/$(shell uname -n)/openid
	tailscale serve status
	cd ./r/digest && $(MAKE) cache
	$(MAKE) iam

iam:
	PAGER= HOST="$$(tailscale funnel status | grep ^#  | grep https:// | head -1 | cut -d/ -f3-)" \
		&& set -x \
		&& (echo \
			| openssl s_client -servername $$HOST -showcerts -connect $$HOST:443 2> /dev/null \
			| sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$$x' -e '$$p' \
			| tail +2 \
			| openssl x509 -fingerprint -noout \
			| sed -e "s/.*=//" -e "s/://g" \
			| tr "A-F" "a-f") \
		&& OPENID_HOST=$${HOST%%.*} \
		&& (aws iam create-role \
			--role-name $${OPENID_HOST}-cluster \
			--assume-role-policy-document \
			file://<(env ACCOUNT_ID=$(shell  aws sts get-caller-identity | jq -r '.Account') OPENID=$${HOST}/openid envsubst <trust-policy.json) || true) \
		&& (aws iam attach-role-policy \
			--role-name $${OPENID_HOST}-cluster \
			--policy-arn arn:aws:iam::aws:policy/AdministratorAccess || true)

up:
	cd .. && bin/make-k3s up

down:
	cd .. && bin/make-k3s down
