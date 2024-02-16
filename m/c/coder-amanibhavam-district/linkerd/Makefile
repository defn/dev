save = cache.defn.run:5000/demo

all: ca.crt ca.key cluster.crt cluster.key

ca.crt ca.key:
	step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure

cluster.crt cluster.key: ca.crt ca.key
	step certificate create identity.linkerd.cluster.local cluster.crt cluster.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key

server: ca.key
	spire-server run

agent: ca.crt
	spire-agent run \
		-joinToken "$$(spire-server token generate \
		-spiffeID spiffe://root.linkerd.cluster.local/agent \
		-output json | jq -r .value)"

entry: ca.key
	spire-server entry create \
		-parentID spiffe://root.linkerd.cluster.local/agent \
		-spiffeID spiffe://root.linkerd.cluster.local/meh \
		-selector unix:uid:$$(id -u)

shell:
	docker run --rm -ti -v /nix:/nix -v ~/bin/nix:/usr/local/bin \
		--entrypoint $$(readlink ~/bin/nix/bash) $(save)

image:
	earthly --push +demo --image=ghcr.io/linkerd/proxy:$$(linkerd version --proxy --client --short) --save $(save)
