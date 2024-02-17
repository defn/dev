SHELL := /bin/bash

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

from ?= $(env)

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

test:
# make test
	kubectl --context $(env) delete ns cilium-test || true
	cilium connectivity test --context $(env)
	kubectl --context $(env) delete ns cilium-test || true

disconnect:
# make disconnect from=coder-amanibhavam-district to=coder-amanibhavam-school
	cilium clustermesh disconnect --context $(from) --destination-context=$(to)

connect:
# make connect from=coder-amanibhavam-district to=coder-amanibhavam-school
	$(MAKE) connect_inner from=$(from) to=$(to) endpoint=$$(kubectl --context $(to) get services -n kube-system -o json clustermesh-apiserver | jq -r '.status.loadBalancer.ingress[].ip'):2379
	$(MAKE) connect_inner from=$(to) to=$(from) endpoint=$$(kubectl --context $(from) get services -n kube-system -o json clustermesh-apiserver | jq -r '.status.loadBalancer.ingress[].ip'):2379
	cilium clustermesh status --context $(from) --wait
	cilium clustermesh status --context $(to) --wait

connect_inner:
	cilium clustermesh connect --context $(from) --destination-context $(to) --destination-endpoint $(endpoint)

test-mesh:
# make test-mesh from=coder-amanibhavam-school to=coder-amanibhavam-district
	kubectl --context $(from) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test || true
	cilium connectivity test --context $(from) --multi-cluster $(to) --test '!/node-to-node-encryption' --test '!/no-unexpected-packet-drops'
	kubectl --context $(from) delete ns cilium-test || true
	kubectl --context $(to) delete ns cilium-test

config-district:
	cd .. && $(MAKE) tailscale-kubeconfig env=coder-amanibhavam-district

config-school:
	cd .. && $(MAKE) tailscale-kubeconfig env=coder-amanibhavam-school

start-school:
	coder start --yes school

start-all:
	$(MAKE) -j 2 start-school
	coder config-ssh --yes
	for a in school; do ssh coder.$$a bash -c "'cd m && make ready'"; done

stop-school:
	coder stop --yes school || true

stop-all:
	$(MAKE) -j 2 stop-school

test-all:
	$(MAKE) test-mesh from=coder-amanibhavam-district to=coder-amanibhavam-school
	$(MAKE) test-mesh from=coder-amanibhavam-school   to=coder-amanibhavam-district

status:
	@mark cilium
	k --context=$(env) exec -n kube-system -ti ds/cilium -- cilium status
	@mark clustermesh
	k --context=$(env) exec -n kube-system -ti ds/cilium -- cilium-health status
	@mark hubble
	k --context=$(env) exec -n kube-system ds/cilium -- hubble status
	@mark cli
	cilium status --context=$(env)
	cilium clustermesh status --context=$(env)

# https://github.com/cilium/cilium/issues/13766
restart-cilium:
	kubectl -n kube-system rollout restart deploy cilium-operator
	kubectl -n kube-system rollout restart ds cilium 
	kubectl -n kube-system rollout restart deploy hubble-relay
	kubectl -n kube-system rollout restart deploy hubble-ui
	kubectl -n kube-system rollout restart deploy clustermesh-apiserver

xwing-attack:
	kubectl exec --context coder-amanibhavam-school -ti deploy/xwing -- curl -XPUT -H 'X-Has-Force: True' deathstar.default.svc.cluster.local/v1/exhaust-port

xwing-visit:
	kubectl exec --context coder-amanibhavam-school -ti deploy/xwing -- curl -XGET deathstar.default.svc.cluster.local/v1/

spaceship-attack:
	kubectl exec --context coder-amanibhavam-school -ti deploy/spaceship -- curl -XPUT -H 'X-Has-Force: True' deathstar.default.svc.cluster.local/v1/exhaust-port

spaceship-visit:
	kubectl exec --context coder-amanibhavam-school -ti deploy/spaceship -- curl -XGET deathstar.default.svc.cluster.local/v1/

mirrord-attack:
	mirrord exec -f ~/m/mirrord.json --context coder-amanibhavam-district -- curl -XPUT -H 'X-Has-Mirrord: True' deathstar.default.svc.cluster.local/v1/exhaust-port

mirrord-visit:
	mirrord exec -f ~/m/mirrord.json --context coder-amanibhavam-district -- curl -XGET deathstar.default.svc.cluster.local/v1/
