SHELL := /bin/bash

app ?= district school class district0 district1

digest ?= 

env ?= $(shell uname -n | cut -d- -f3)

delivery:
	$(MAKE) all digest=$(digest)
	$(MAKE) all

build:
	cd $(shell uname -n) && $(MAKE) build
	$(MAKE) release

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

helm_add:
	(cd .. && git grep repo: kustomize.cue) | cut -d'"' -f2 | sort -u | while read -r repo; do helm repo add $$(echo $$repo | cut -d/ -f3- | perl -pe 's{\s+$$}{}; s{\W+}{-}g') $$repo; done
	helm repo update

build-all:
# cant run in parallel due to git
	runmany 1 'cd $$1 && make' coder-*/

release-all:
	$(MAKE) build-all
	$(MAKE) release digest=$(digest)

all:
	$(MAKE) crd release-all digest=$(digest)
	if env GIT_PAGER=cat git grep not-found ../h; then $(MAKE) digest release; fi
	cd ../k && $(MAKE) delivery

digest:
	cd ./r && $(MAKE) digest

release:
	$(MAKE) release_k_y
	$(MAKE) release_k_r

release_k_y:
# make one big cue config
	rm -f ../k/y/cluster.cue
	(echo package y; for r in ../k/y/*/main.yaml; do echo $$r 1>&2; (cue import $$r -p r --with-context -l '"res"' -l 'strings.ToLower(data.kind)' -l 'path.Dir(path.Rel("$(shell cd ../k/y && pwd)",filename))' -l 'strings.ToLower(*data.metadata.namespace | "cluster")' -l data.metadata.name --outfile - \
		| grep -v '^package '); done) > ../k/y/cluster.cue
	perl -pe 's{^\s*\w+:\s+null\s*}{}; s{data: null,}{}' -i ../k/y/cluster.cue
	git add ../k/y

release_k_r:
# generate k/r
	rm -rf ../k/r
	if test -n "$(digest)"; then $(MAKE) digest; fi
	cd ./r/digest && $(MAKE) release
	rm -rf ../k/r/y
	git add ../k/r

cache:
	cd ./r/digest && $(MAKE) cache filter=$(filter)

once:
	cd .. && bin/make-k3s init
	$(MAKE) cache
	$(MAKE) tailscale
	$(MAKE) iam

tailscale:
	mkdir -p ./$(shell uname -n)/openid
	sudo tailscale funnel --bg --https=443 --set-path /openid $(shell pwd)/$(shell uname -n)/openid

iam:
	AWS_PAGER= HOST="$$(tailscale funnel status | grep ^#  | grep https:// | head -1 | cut -d/ -f3-)" \
		&& export AWS_PAGER HOST \
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

last:
	tailscale up --advertise-routes=$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP' | cut -d. -f1-2).0.0/16 --accept-routes --ssh

up:
	cd .. && bin/make-k3s up

down:
	cd .. && bin/make-k3s down

test:
	kubectl --context $$(uname -n) delete ns cilium-test || true
	cilium connectivity test --context $$(uname -n) --test '!/(node|pod)-to-(node|pod)-encryption'
	kubectl --context $$(uname -n) delete ns cilium-test || true

test-mesh:
	kubectl --context $$(uname -n) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test || true
	cilium connectivity test --context $$(uname -n) --multi-cluster $(to) --test '!/node-to-node-encryption'
	kubectl --context $$(uname -n) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test

restart-mesh:
	runmany 3 'coder restart -y $$1' $(app)
	$(MAKE) wait-mesh

start-mesh:
	runmany 3 'coder start -y $$1' $(app)
	$(MAKE) wait-mesh

wait-mesh:
	for a in $(app); do ssh coder.$$a bash -c '"cd m/c && cilium clustermesh status --wait"'; done

stop-mesh:
	runmany 3 'coder stop -y $$1' $(app)

connect:
	cilium clustermesh connect --context $$(uname -n) --destination-context $(to) --destination-endpoint $(endpoint)

# https://github.com/cilium/cilium/issues/13766
restart-cilium:
	kubectl -n kube-system rollout restart deploy cilium-operator
	kubectl -n kube-system rollout restart ds cilium 
	kubectl -n kube-system rollout restart deploy hubble-relay
	kubectl -n kube-system rollout restart deploy hubble-ui
	kubectl -n kube-system rollout restart deploy clustermesh-apiserver

token:
	@kubectl create token headlamp-admin -n headlamp

status:
	kubectl exec -ti -n kube-system ds/cilium -- cilium status
	kubectl exec -ti -n kube-system ds/cilium -- cilium-health status
	kubectl exec -ti -n kube-system ds/cilium -- hubble status
	cilium status
	cilium clustermesh status

xwing-visit:
	kubectl exec -ti deploy/xwing -- curl -XGET deathstar.default.svc.cluster.local/v1/

visit:
	kubectl exec -ti deploy/spaceship -- curl -XGET deathstar.default.svc.cluster.local/v1/

attack:
	kubectl exec -ti deploy/xwing -- curl -XPUT -H 'X-Has-Force: True' deathstar.default.svc.cluster.local/v1/exhaust-port

crd:
	cd ../k/y && cue export --out json -e crds | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | while read -r domain crds; do echo "$$crds" | base64 -d > ../crd/$$domain.yaml; done

update-env:
	app set coder-amanibhavam-$(env)-cluster --revision $$(helm show chart --insecure-skip-tls-verify oci://cache.defn.run:5000/library/helm/coder-amanibhavam-$(env)-cluster-env 2>/dev/null | grep ^version: | awk '{print $$2}')

diff-chart:
	h=oci://cache.defn.run:5000/library/helm/coder-amanibhavam-$(env)-cluster-$(app); dyff --color=on between <(helm template --insecure-skip-tls-verify $$h --version $(from) 2>/dev/null) <(helm template --insecure-skip-tls-verify $$h --version $(to) 2>/dev/null) | less -r
