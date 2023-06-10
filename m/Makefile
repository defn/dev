build:
	bazel build //cmd/cli:cli

all:
	bazel build //...

up:
	nix develop --command tilt up --stream --port=0

wrappers:
	 grep profile ~/.aws/config | grep 'sso-source' | awk '{print $$2}' | cut -d- -f1-2 | grep -v sso | runmany 4 'bazel run --script_path=bin/$$1 //meh:aws $$1'

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
	git ls-files | grep cue.mod | perl -pe 's{(cue.mod).*}{$$1}' | sort -u >> .bazelignore
	echo cmd/cli/proto >> .bazelignore

update-repos:
	@mark gazelle-buf-update-repos
	bazel run //:gazelle-buf-update-repos

	@mark gazelle-update-repos
	bazel run //:gazelle-update-repos

	@mark gazelle-buf
	bazel run //:gazelle-buf

	@mark gazelle
	bazel run //:gazelle

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