build:
	../bin/b pass build //cmd/cli:cli

all:
	b pass build //...

todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

ci:
	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=5 buildkite-agent start --build-path ~/work/buildkite-agent --plugins-path ~/work/buildkite-plugins --token "$$(pass BUILDKITE_AGENT_TOKEN)"

dev:
# rm -rf ~/Library/App*/coderv2/postgres
	coder server --disable-password-auth --oauth2-github-allow-signups --oauth2-github-allowed-orgs $$(pass coder_oauth2-github-allowed-orgs) --oauth2-github-allowed-teams $$(pass coder_oauth2-github-allowed-teams) --oauth2-github-client-id $$(pass coder_oauth2-github-client-id) --oauth2-github-client-secret $$(pass coder_oauth2-github-client-secret)

up:
#screen -S tilt -d -m bash -il -c "tilt up --stream --port=10351"
	tilt up --stream --port=10351

cdktf:
	npm install
	npx cdktf get
	$(MAKE) regen

upgrade:
	go get -u  ./...
	go mod tidy

update:
	$(MAKE) bazel-ignore

regen:
	@mark defn.dev protos
	cd defn/dev && $(MAKE)

	@mark gazelle-buf-update-repos
	b pass run //:gazelle-buf-update-repos

	@mark gazelle-update-repos
	b pass run //:gazelle-update-repos

	@mark gazelle-buf
	b pass run //:gazelle-buf

	@mark gazelle
	b pass run //:gazelle

watch:
	$(MAKE) build
	ibazel build //...

bazel-ignore:
	echo > .bazelignore
	echo tf >> .bazelignore
	echo node_modules >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1.direnv}' | sort >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1result}' | sort >> .bazelignore

nix-build-all:
	git ls-files | grep flake.nix | perl -pe 's{/?flake.nix}{}' | runmany 'mark $$1; cd ./$$1 && nix build'

k3s-oidc:
	awk -F': ' '/client-certificate-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.admin.pem && chmod 600 system.admin.pem
	awk -F': ' '/client-key-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.admin.key && chmod 600 system.admin.key
	awk -F': ' '/certificate-authority-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.ca.pem && chmod 600 system.ca.pem
	mkdir -p oidc/.well-known oidc/v1
	openssl x509 -in system.ca.pem -fingerprint -noout | awk -F'=' 'gsub(/:/,"",$$0) { print $$2 }' > oidc/thumbprint && chmod 600 oidc/thumbprint
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem https://localhost:6443/.well-known/openid-configuration > oidc/.well-known/openid-configuration
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem https://localhost:6443/openid/v1/jwks > oidc/v1/jwks

k3d-update:
	curl -sSL -o k3d-tailscale-operator.yaml https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml
	trunk fmt k3d-tailscale-operator.yaml

k3d-ca:
	step certificate create cilium-ca ca.crt ca.key --profile root-ca --not-after 8760h --no-password --insecure --kty RSA --size 4096 --force

k3d-secrets:
	-kubectl create secret generic -n kube-system cilium-ca --from-file=ca.key --from-file=ca.crt
	-kubectl create secret generic -n cert-manager cilium-ca --from-file=tls.key=ca.key --from-file=tls.crt=ca.crt