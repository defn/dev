timeout ?= 5

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)
domain ?= defn.run

build:
	../bin/b pass build //cmd/cli:cli
	cp -f bazel-bin/cmd/cli/cli_/cli /tmp/cli

all:
	$(MAKE) update ci
	$(MAKE) build update upgrade regen
	$(MAKE) build update ci
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
	$(MAKE) ci_inner

ci_web:
	cd defn/dev/www && $(MAKE) build
	cd && git add docs
	git commit -m 'update docs' || true

ci_inner:
#	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=$(timeout) buildkite-agent start --build-path ~/work/buildkite-agent --plugins-path ~/work/buildkite-plugins --token "$$(pass BUILDKITE_AGENT_TOKEN)"
#	cd && env CACHIX_AUTH_TOKEN=$$(pass CACHIX_AUTH_TOKEN) make cache
	cd pkg && b build

teacher-clean:
	rm -rf ~/Library/App*/coderv2/postgres

teacher-init:
	coder login https://$(shell tailscale cert 2>&1 | grep 'For domain'  | cut -d'"' -f2) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

class-init:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

teacher: 
	pass hello
	tailscale serve --bg http://127.0.0.1:3000
	b server defn-org $(MAKE) dev_inner 

dev_inner:
	coder server --oauth2-github-allow-signups \
		--enable-terraform-debug-mode \
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
	cd tf && source ./.envrc && cd stacks && runmany 'cd $$1 && tf upgrade && tf locks && tf plan' */
	$(MAKE) bazel-ignore
	$(MAKE) cdktf
	$(MAKE) build
	cd tf && cli infra

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
	echo cutout >> .bazelignore
	git ls-files | grep '{{cookiecutter' | perl -pe 's{\}\}/.*}{\}\}}' | sort -u >> .bazelignore
	git ls-files | grep '{{cookiecutter' | perl -pe 's{/\{\{.*}{}' | sort -u >> .bazelignore

docker:
	cd i/docker && $(MAKE) build

.PHONY: aws
aws:
	cd i/aws && $(MAKE) build

warudo:
	pass hello
	$(MAKE) ci
	$(MAKE) -j 2 docker #aws

coder-login:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain)

coder-admin:
	k exec -n coder -ti deploy/coder -- bash -c 'coder server create-admin-user --email iam+admin@defn.sh --password admin --username admin --postgres-url postgresql://coder:$$(cat ~/.config/coderv2/postgres/password)@localhost:$$(cat ~/.config/coderv2/postgres/port)/?sslmode=disable'
	$(MAKE) coder-login
	cd coder/pod && $(MAKE) push

self-cert:
	step certificate create --subtle --insecure --no-password --force --profile self-signed $(env) $(env).crt $(env).key

once:
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification
	cd k && $(MAKE) all-push
	cd c && $(MAKE) cache
	$(MAKE) update-env env=$(env)

vc-context:
	env KUBECONFIG=$$HOME/.kube/config-in-cluster vcluster connect vcluster -n $(env) --server=$$(env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl get -n $(env) svc vcluster -o json | jq -r '.spec.clusterIP'):443 --update-current=false --kube-config-context-name $(env)-cluster --kube-config "$$HOME/.kube/config"
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd

vc-argocd:
	-env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core rm $(env)-cluster --yes
	env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core add $(env)-cluster --yes --upsert

vc:
	$(MAKE) vc-context
	chmod 0600 ~/.kube/config
	$(MAKE) vc-argocd
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl apply -f e/$(env)-cluster.yaml
	cd c && env KUBECONFIG=$$HOME/.kube/config-in-cluster $(MAKE) update-env env=$(env)

dev:
	cp /home/ubuntu/.kube/config /home/ubuntu/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config.argocd k config set-context --current --namespace argocd
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification

init:
	cd && $(MAKE) install
	cd && ./.dotfiles/bootstrap
	cd c && $(MAKE) tailscale
	$(MAKE) cache

up:
	bin/make-k3s up
# dunno why kyverno application isn't create the ns
	k create ns kyverno || true
	cd c && $(MAKE) iam
	$(MAKE) ready

ready:
	$(MAKE) k3s-restart-irsa
	$(MAKE) k3s-advertise-traefik

.PHONY: cache
cache:
	cd cache && $(MAKE) up
	cd k && $(MAKE) cache
	cd c && $(MAKE) cache

recreate:
	-bin/make-k3s down
	$(MAKE) up

k3s-restart-irsa:
	while ! kubectl rollout -n kube-system status deployment pod-identity-amazon-eks-pod-identity-webhook; do sleep 10; done
	-kubectl rollout -n external-secrets restart deployment
	-kubectl rollout -n karpenter restart deployment

k3s-advertise-traefik:
	while ! kubectl rollout -n traefik status deployment traefik; do sleep 10; done
	sudo ethtool -K "$$(ip route show 0/0 | cut -f5 -d' ')" rx-udp-gro-forwarding on rx-gro-list off
	while true; do if test -n "$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP')"; then break; fi; sleep 5; done
	tailscale up --advertise-routes=$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP')/32,$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP' | cut -d. -f1-2).128.53/32  --accept-routes=true --ssh

tailscale-kubeconfig:
	tailscale configure kubeconfig $(env)-proxy
	-kubectl config delete-context $(env)
	kubectl config rename-context $(env)-proxy.$(shell tailscale cert 2>&1 | grep 'use ' | cut -d'"' -f2 | cut -d. -f2-) $(env)
