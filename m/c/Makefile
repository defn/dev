SHELL := /bin/bash

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

list:
	@(cd .. && git grep artifacthub) | awk '{print $$2}' | runmany 'curl -sSL https://artifacthub.io/api/v1/$${1#https://artifacthub.io/}/feed/rss 2>/dev/null | grep 'artifacthub.io/packages/helm/' | grep -v -E "beta|snapshot" | head -1 | cut -d">" -f2 | cut -d"<" -f1' | sort -u > pending.txt
	git diff pending.txt

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
	cilium clustermesh status --wait

stop-school:
	coder stop --yes school || true

stop-all:
	$(MAKE) -j 2 stop-school

test-all:
	$(MAKE) test-mesh from=coder-amanibhavam-district to=coder-amanibhavam-school
	$(MAKE) test-mesh from=coder-amanibhavam-school   to=coder-amanibhavam-district

connect:
# k get services -n kube-system clustermesh-apiserver
# use external-IP
# make connect from=coder-amanibhavam-school to=coder-amanibhavam-district endpoint=172.31.33.178:2379
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
