all: ca.crt ca.key cluster.crt cluster.key bin/spire-agent bin/spire-server

ca.crt ca.key:
	step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure

cluster.crt cluster.key: ca.crt ca.key
	step certificate create identity.linkerd.cluster.local cluster.crt cluster.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key

bin/spire-agent bin/spire-server:
	curl -sSL -o spire.tar.gz https://github.com/spiffe/spire/releases/download/v1.8.7/spire-1.8.7-linux-amd64-musl.tar.gz
	tar xvfz spire.tar.gz
	mv spire-1.8.7/bin/* bin/
	rm -rf spire.tar.gz spire-1.8.7

server: bin/spire-server ca.key
	./bin/spire-server run

agent: bin/spire-agent bin/spire-server ca.crt
	./bin/spire-agent run \
		-joinToken "$$(./bin/spire-server token generate \
		-spiffeID spiffe://root.linkerd.cluster.local/agent \
		-output json | jq -r .value)"

entry: bin/spire-server ca.key
	./bin/spire-server entry create \
		-parentID spiffe://root.linkerd.cluster.local/agent \
		-spiffeID spiffe://root.linkerd.cluster.local/meh \
		-selector unix:uid:$$(id -u)