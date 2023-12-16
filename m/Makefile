timeout ?= 5

env ?= $(shell uname -n | cut -d- -f3)
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
	b server defn-org $(MAKE) ci_inner 

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
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

teacher: 
	pass hello
	tailscale serve --bg http://127.0.0.1:3000
	b server defn-org $(MAKE) dev_inner 

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

za:
	pass hello
	cd coder/class && $(MAKE) image

warudo:
	pass hello
	this-prune
	$(MAKE) ci za

coder-login:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain)

coder-admin:
	k exec -n coder -ti deploy/coder -- bash -c 'coder server create-admin-user --email iam+admin@defn.sh --password admin --username admin --postgres-url postgresql://coder:$$(cat ~/.config/coderv2/postgres/password)@localhost:$$(cat ~/.config/coderv2/postgres/port)/?sslmode=disable'
	$(MAKE) coder-login
	cd coder/pod && $(MAKE) push

self-cert:
	step certificate create --subtle --insecure --no-password --force --profile self-signed $$(uname -n) $$(uname -n).crt $$(uname -n).key

once:
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification
	cd k && $(MAKE) all-push
	cd c && $(MAKE) cache
	$(MAKE) update-env env=$(env)

vc-context:
	env KUBECONFIG=$$HOME/.kube/config-in-cluster vcluster connect vcluster -n $$(uname -n | cut -d- -f1-3) --server=$$(env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl get -n $$(uname -n | cut -d- -f1-3) svc vcluster -o json | jq -r '.spec.clusterIP'):443 --update-current=false --kube-config-context-name $$(uname -n | cut -d- -f1-3)-cluster --kube-config "$$HOME/.kube/config"
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd

vc-argocd:
	-env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core rm $$(uname -n | cut -d- -f1-3)-cluster --yes
	env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core add $$(uname -n | cut -d- -f1-3)-cluster --yes --upsert

vc:
	$(MAKE) vc-context
	chmod 0600 ~/.kube/config
	$(MAKE) vc-argocd
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl apply -f e/$$(uname -n | cut -d- -f1-3)-cluster.yaml
	cd c && env KUBECONFIG=$$HOME/.kube/config-in-cluster $(MAKE) update-env env=$$(uname -n | cut -d- -f3)

vc-init:
	kubectl patch -n argocd secret argocd-secret -p '{"stringData": { "admin.password": "'$$(htpasswd -bnBC 10 "" admin | tr -d ':\n')'"}}'

dev:
	cp /home/ubuntu/.kube/config /home/ubuntu/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config.argocd k config set-context --current --namespace argocd
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification

k3s-init:
	bin/make-k3s init
	cd c && $(MAKE) tailscale
	cd k && $(MAKE) cache
	cd c && $(MAKE) cache

k3s-recreate:
	-bin/make-k3s down
	$(MAKE) k3s-up

k3s-up:
	bin/make-k3s up
	cd c && $(MAKE) iam
	$(MAKE) k3s-restart-irsa
	$(MAKE) k3s-wait

k3s-restart-irsa:
	while ! kubectl rollout -n kube-system status deployment pod-identity-amazon-eks-pod-identity-webhook; do sleep 10; done
	-kubectl rollout -n external-secrets restart deployment
	-kubectl rollout -n karpenter restart deployment

k3s-wait:
	sudo ethtool -K "$$(ip route show 0/0 | cut -f5 -d' ')" rx-udp-gro-forwarding on rx-gro-list off
	while true; do if test -n "$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP' | cut -d. -f1-2).0.0/16 --accept-routes --ssh"; then break; fi; sleep 5; done
	tailscale up --advertise-routes=$$(kubectl get -n traefik svc traefik -o json | jq -r '.spec.clusterIP' | cut -d. -f1-2).0.0/16 --accept-routes --ssh
