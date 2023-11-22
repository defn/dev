timeout ?= 5

build:
	../bin/b pass build //cmd/cli:cli
	cp -f bazel-bin/cmd/cli/cli_/cli /tmp/cli

all:
	$(MAKE) ci build update upgrade regen build update ci
	cd c && $(MAKE) all
	b pass build //...

image:
	cp -f bazel-bin/cmd/cli/cli_/cli cli.bin
	docker build -t $(tag) .
	rm -f cli.bin
	docker push $(tag)

todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

ci: 
	b server defn-org-sso $(MAKE) ci_inner 

ci_web:
	cd defn/dev/www && $(MAKE) build
	cd && git add docs
	git commit -m 'update docs' || true

ci_inner:
	$(MAKE) ci_web
#	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=$(timeout) buildkite-agent start --build-path ~/work/buildkite-agent --plugins-path ~/work/buildkite-plugins --token "$$(pass BUILDKITE_AGENT_TOKEN)"
	cd && env CACHIX_AUTH_TOKEN=$$(pass CACHIX_AUTH_TOKEN) make cache
	cd && $(MAKE) install

teacher-clean:
	rm -rf ~/Library/App*/coderv2/postgres

teacher-init:
	coder login https://$(shell tailscale cert 2>&1 | grep 'For domain'  | cut -d'"' -f2) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

class-init:
	coder login https://coder.dev.amanibhavam.defn.run --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

teacher: 
	pass hello
	tailscale serve --bg http://127.0.0.1:3000
	b server defn-org-sso $(MAKE) dev_inner 

dev_inner:
	coder server --oauth2-github-allow-signups \
		--oauth2-github-allowed-orgs $$(pass coder_oauth2-github-allowed-orgs) --oauth2-github-allowed-teams $$(pass coder_oauth2-github-allowed-teams) \
		--oauth2-github-client-id $$(pass coder_oauth2-github-client-id) --oauth2-github-client-secret $$(pass coder_oauth2-github-client-secret) \
		--access-url https://$(shell tailscale cert 2>&1 | grep 'For domain'  | cut -d'"' -f2)

cdktf:
	npm install
	npx cdktf get
	$(MAKE) regen

upgrade:
	npm install
	npm upgrade
	npm outdated
	go get -u  ./...
	go mod tidy

update:
	$(MAKE) bazel-ignore
	$(MAKE) cdktf
	$(MAKE) build
	cd tf && cli infra
	cd tf && source ./.envrc && cd stacks && runmany 'cd $$1 && tf upgrade && tf locks && tf plan' */

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

za:
	pass hello
	cd coder/class && $(MAKE) image

coder-login:
	coder login https://coder.dev.amanibhavam.defn.run

coder-admin:
	k exec -n coder -ti deploy/coder -- bash -c 'coder server create-admin-user --email iam+admin@defn.sh --password admin --username admin --postgres-url postgresql://coder:$$(cat ~/.config/coderv2/postgres/password)@localhost:$$(cat ~/.config/coderv2/postgres/port)/?sslmode=disable'
	$(MAKE) coder-login
	cd coder/pod && $(MAKE) push

self-cert:
	step certificate create --subtle --insecure --no-password --force --profile self-signed $$(uname -n) $$(uname -n).crt $$(uname -n).key

once:
	app repo add cache.defn.run:5000 --type helm --name cache --enable-oci --insecure-skip-server-verification
	cd k && $(MAKE) all-push
	cd c && $(MAKE) cache
	$(MAKE) update-env env=$(env)

vc-context:
	env KUBECONFIG=$$HOME/.kube/config-in-cluster vcluster connect vcluster -n $$(uname -n | cut -d- -f1-3) --server=$$(env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl get -n $$(uname -n | cut -d- -f1-3) svc vcluster -o json | jq -r '.spec.clusterIP'):443 --update-current=false --kube-config-context-name $$(uname -n | cut -d- -f1-3)-cluster --kube-config "$$HOME/.kube/config"
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd

vc-argocd:
	env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core rm $$(uname -n | cut -d- -f1-3)-cluster --yes
	env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core add $$(uname -n | cut -d- -f1-3)-cluster --yes --upsert

vc:
	$(MAKE) vc-context
	$(MAKE) vc-argocd
	env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl apply -f e/$$(uname -n | cut -d- -f1-3)-cluster.yaml
	cd c && env KUBECONFIG=$$HOME/.kube/config-in-cluster $(MAKE) update-env env=$$(uname -n | cut -d- -f3)
