SHELL := /bin/bash

digest ?= 

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

delivery:
	while true; do \
		time $(MAKE) delivery_inner; \
		if ! git diff coder-* | grep app_version:; then break; fi; \
		git add -u coder-*; \
		done

# M k/crd/ENV.yaml
	$(MAKE) crd

delivery_inner:
	@mark delivery_inner
# M k/y/cluster.cue updated
# M k/y/APP/main.yaml
# M k/APP/kustomization.yaml
# images are original
	$(MAKE) build

# M k/r/APP/main.yaml
# images are rewritten to use cache URLs, which may not be found in the cache
	$(MAKE) release

# M r/digest/digest_gen.cue
# M k/r/APP/main.yaml
# put missing images into the cache
	if env GIT_PAGER=cat git grep image:.not-found ../k/r; then $(MAKE) digest release; fi

# h/APP*
# ENV/APP-version.cue
	$(MAKE) chart

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

chart:
	cd ../k && $(MAKE) delivery

helm_add:
	(cd .. && git grep repo: kustomize.cue) | cut -d'"' -f2 | sort -u | while read -r repo; do helm repo add $$(echo $$repo | cut -d/ -f3- | perl -pe 's{\s+$$}{}; s{\W+}{-}g') $$repo; done
	helm repo update

digest:
	cd ./r && $(MAKE) digest

build:
	runmany 1 'cd $$1 && make' coder-*
	$(MAKE) cluster_cue

cluster_cue:
# make one big cue config
	(echo package y; for r in ../k/y/*/main.yaml; do \
		echo $${r%%/main.yaml}.cue | sed 's#.*/##' 1>&2; \
		(cue import $$r -p y --with-context \
			-l '"res"' -l 'strings.ToLower(data.kind)' -l 'path.Dir(path.Rel("$(shell cd ../k/y && pwd)",filename))' -l 'strings.ToLower(*data.metadata.namespace | "cluster")' -l data.metadata.name --outfile - \
		| perl -pe 's{^\s*\w+:\s+null\s*}{}') > k/$${r%%/main.yaml}.cue; done)

release:
# remove ANYTHING: null
	(cd r/digest && cue export --out json -e cached_yaml) | jq -r 'to_entries[] | "../k/r/\(.key) \(.value | @base64) 1"' | grep -v -e '^\s*[\w-]+: null\s*$$' | ./release.py

cache:
	cd ./r/digest && $(MAKE) cache filter=$(filter)

tailscale:
	mkdir -p ./$(env)/openid
	sudo tailscale funnel --bg --https=443 --set-path /openid $(shell pwd)/$(env)/openid

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

test:
# make test
	kubectl --context $(env) delete ns cilium-test || true
	cilium connectivity test --context $(env)
	kubectl --context $(env) delete ns cilium-test || true

test-mesh:
# make test-mesh from=coder-amanibhavam-school to=coder-amanibhavam-district
	kubectl --context $(from) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test || true
	cilium connectivity test --context $(from) --multi-cluster $(to) --test '!/node-to-node-encryption' --test '!/no-unexpected-packet-drops'
	kubectl --context $(from) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test

start-school:
	coder start --yes school

start-class:
	coder start --yes class

start-all:
	$(MAKE) -j 2 start-school start-class
	coder config-ssh
	for a in school class; do ssh coder.$$a bash -c "'cd m && make ready'"; done
	cilium clustermesh status --wait

stop-school:
	coder stop --yes school || true

stop-class:
	coder stop --yes class || true

stop-all:
	$(MAKE) -j 2 stop-school stop-class

test-all:
	$(MAKE) test-mesh from=coder-amanibhavam-district to=coder-amanibhavam-school
	$(MAKE) test-mesh from=coder-amanibhavam-district to=coder-amanibhavam-class
	$(MAKE) test-mesh from=coder-amanibhavam-class    to=coder-amanibhavam-district
	$(MAKE) test-mesh from=coder-amanibhavam-class    to=coder-amanibhavam-school
	$(MAKE) test-mesh from=coder-amanibhavam-school   to=coder-amanibhavam-district
	$(MAKE) test-mesh from=coder-amanibhavam-school   to=coder-amanibhavam-class

connect:
# k get services -n kube-system clustermesh-apiserver
# use external-IP
# make connect from=coder-amanibhavam-class to=coder-amanibhavam-district endpoint=172.31.33.178:2379
	cilium clustermesh connect --context $(from) --destination-context $(to) --destination-endpoint $(endpoint)

status:
	@mark cilium
	k exec -n kube-system -ti ds/cilium -- cilium status
	@mark clustermesh
	k exec -n kube-system -ti ds/cilium -- cilium-health status
	@mark hubble
	k exec -n kube-system ds/cilium -- hubble status
	@mark cli
	cilium status
	cilium clustermesh status

# https://github.com/cilium/cilium/issues/13766
restart-cilium:
	kubectl -n kube-system rollout restart deploy cilium-operator
	kubectl -n kube-system rollout restart ds cilium 
	kubectl -n kube-system rollout restart deploy hubble-relay
	kubectl -n kube-system rollout restart deploy hubble-ui
	kubectl -n kube-system rollout restart deploy clustermesh-apiserver

token:
	@kubectl create token headlamp-admin -n headlamp

xwing-attack:
	kubectl exec --context coder-amanibhavam-class -ti deploy/xwing -- curl -XPUT -H 'X-Has-Force: True' deathstar.default.svc.cluster.local/v1/exhaust-port

xwing-visit:
	kubectl exec --context coder-amanibhavam-class -ti deploy/xwing -- curl -XGET deathstar.default.svc.cluster.local/v1/

spaceship-attack:
	kubectl exec --context coder-amanibhavam-school -ti deploy/spaceship -- curl -XPUT -H 'X-Has-Force: True' deathstar.default.svc.cluster.local/v1/exhaust-port

spaceship-visit:
	kubectl exec --context coder-amanibhavam-school -ti deploy/spaceship -- curl -XGET deathstar.default.svc.cluster.local/v1/

crd:
	(cd k/y && cue export --out json -e crds | jq -r 'to_entries[] | "../k/crd/\(.key).yaml \(.value | @base64) 0"') | ./release.py

update-env:
# ensure no argocd-repo-server pods are in a non-Running state, the cli will pick any pod
	app set $(env)-cluster --revision $$(helm show chart --insecure-skip-tls-verify oci://cache.defn.run:5000/library/helm/$(env)-cluster-env 2>/dev/null | grep ^version: | awk '{print $$2}')

diff-chart:
	h=oci://cache.defn.run:5000/library/helm/$(env)-cluster-$(app); dyff --color=on between <(helm template --insecure-skip-tls-verify $$h --version $(from) 2>/dev/null) <(helm template --insecure-skip-tls-verify $$h --version $(to) 2>/dev/null) | less -r
