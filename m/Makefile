build:
	../bin/b pass build //cmd/cli:cli

all:
	b pass build //...

todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

ci:
	buildkite-agent start --build-path /cache/buildkite --token "$$(pass BUILDKITE_AGENT_TOKEN)"

up:
	screen -S tilt -d -m bash -il -c "tilt up --stream --port=10351"

cdktf:
	npm install
	npx cdktf get
	$(MAKE) regen

upgrade:
	go get -u  ./...
	go mod tidy

update:
	go mod tidy
	$(MAKE) bazel-ignore

regen:
	cd a && buf generate && (find . -name 'BUILD.bazel' | xargs rm -fv)
	$(MAKE) update-repos
	cd a && $(MAKE)
	trunk fmt

watch:
	$(MAKE) build
	ibazel build //...

bazel-ignore:
	echo > .bazelignore
	echo tf >> .bazelignore
	echo node_modules >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1.direnv}' | sort >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1result}' | sort >> .bazelignore

update-repos:
	@mark gazelle-buf-update-repos
	b pass run //:gazelle-buf-update-repos

	@mark gazelle-update-repos
	b pass run //:gazelle-update-repos

	@mark gazelle-buf
	b pass run //:gazelle-buf

	@mark gazelle
	b pass run //:gazelle

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