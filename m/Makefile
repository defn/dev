default:
	$(MAKE) install

-include common/Makefile.coder

timeout ?= 2592000

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

name ?= local
domain ?= defn.run
listen ?= 127.0.0.1:3443

proxy ?= proxy3

install:
	npm -q --no-update-notifier --no-audit install

work ?=
dev-macos:
# keep this for the folder-uri opening technique
	@if test -n "$${REMOTE_CONTAINERS_IPC:-}"; then \
		direnv allow; \
		bash .direnv/bin/nix-direnv-reload 2>/dev/null || true; \
		bash; \
	else \
		code --folder-uri "vscode-remote://dev-container+$$(pwd | perl -pe 's{\s+$$}{}' | xxd -p)/home/ubuntu/m/$(work)" 2>/dev/null; \
	fi

all:
	rm -f MODULES.bazel.lock
	$(MAKE) bazel-ignore
	$(MAKE) regen build
	$(MAKE) trunk
	trunk fmt

build:
	b build

image:
	cp -f bazel-bin/cmd/cli/cli_/cli cli.bin
	docker build -t $(tag) .
	rm -f cli.bin
	docker push $(tag)

todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

ci: 
	$(MAKE) ci_inner

ci_inner:
	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=$(timeout) buildkite-agent start --build-path ~/work/buildkite-agent --plugins-path ~/work/buildkite-plugins --token "$$(pass BUILDKITE_AGENT_TOKEN)"

ci_web:
	cd defn/dev/www && $(MAKE) build
	cd && git add docs
	git commit -m 'update docs' || true

teacher-clean:
	rm -rf ~/Library/App*/coderv2/postgres

teacher-init:
	coder login https://$(shell tailscale cert 2>&1 | grep 'For domain'  | cut -d'"' -f2) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

class-init:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

teacher: 
	$(MAKE) hello
	pkill postgres || true
	env AWS_DEFAULT_REGION=us-west-1 j aws::server defn-org $(MAKE) dev_inner name=$(name)

dev_inner:
	coder server --oauth2-github-allow-signups \
		--enable-terraform-debug-mode \
		--oauth2-github-allowed-orgs $$(pass coder_oauth2-github-allowed-orgs) --oauth2-github-allowed-teams $$(pass coder_oauth2-github-allowed-teams) \
		--oauth2-github-client-id $$(pass coder_oauth2-github-client-id-$(name)) --oauth2-github-client-secret $$(pass coder_oauth2-github-client-secret-$(name)) \
		--access-url "https://coder.$(name).$(domain)" --wildcard-access-url "*.$(name).$(domain)" \
		--tls-enable \
		--tls-cert-file ~/.acme.sh/\*.$(name).$(domain)_ecc/fullchain.cer --tls-key-file ~/.acme.sh/\*.$(name).$(domain)_ecc/\*.$(name).$(domain).key \
		--tls-address $(listen)

cdktf:
	npm -q --no-update-notifier --no-audit install
	cd tf && npx cdktf get
	$(MAKE) regen

upgrade:
	npm -q --no-update-notifier --no-audit install
	npm -q --no-update-notifier --no-audit upgrade
	npm -q --no-update-notifier --no-audit outdated

go-upgrade:
	set -x; go get -u $$(git ls-files | grep 'go$$' | perl -pe 's{[^/]+$$}{\n}' | sort -u | runmany 4 1 'echo ./$$1' | grep -v /demo/)

update:
# cd tf && env SYNTH_HCL_OUTPUT=true cli infra && terraform fmt cdktf.out/stacks/*
	$(MAKE) cdktf

regen:
	$(MAKE) bazel-ignore
	@mark gazelle
	set -x; go get $$(git ls-files | grep 'go$$' | perl -pe 's{[^/]+$$}{\n}' | sort -u | runmany 4 1 'echo ./$$1' | grep -v /demo/)
	mkdir -p node_modules demo/node_modules
	for a in node_modules demo/node_modules infra/stacks/*/.terraform demo/stacks/*/.terraform; do \
		touch $$a/go.mod 2>/dev/null || true; \
	done
	go mod tidy
	b pass run //:gazelle

watch:
	$(MAKE) build
	ibazel build //...

bazel-ignore:
	echo > .bazelignore
	echo tf/mod >> .bazelignore
	echo tf/bootstrap>> .bazelignore
	echo tf/global >> .bazelignore
	echo tf/cdktf.out >> .bazelignore
	echo node_modules >> .bazelignore
	echo demo/node_modules >> .bazelignore
	echo cutout >> .bazelignore
	echo comfyui >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1.direnv}' | sort >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1result}' | sort >> .bazelignore
	git ls-files | grep '{{cookiecutter' | perl -pe 's{\}\}/.*}{\}\}}' | sort -u >> .bazelignore
	git ls-files | grep '{{cookiecutter' | perl -pe 's{/\{\{.*}{}' | sort -u >> .bazelignore
	for a in infra/stacks/*/ infra/cdktf.out/stacks/*/ demo/stacks/*/ demo/cfg/cdktf.out/stacks/*/; do echo "$${a}.terraform"; done | sort >> .bazelignore
	git ls-files | grep /.env | perl -pe 's{/[^/]+$$}{\n}' | while read -r a; do echo "$$a/.direnv"; done | sort >> .bazelignore
	(cat ~/.gitignore && echo && echo m && echo work && echo bin) > ~/.bazelignore

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
	cd k && $(MAKE) update env=$(env)

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
	if env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl apply -f e/$(env)-cluster.yaml; then cd k && env KUBECONFIG=$$HOME/.kube/config-in-cluster $(MAKE) update env=$(env); fi

devx:
	cp /home/ubuntu/.kube/config /home/ubuntu/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config.argocd k config set-context --current --namespace argocd
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification

up:
	bin/make-k3s up
	cd c/$(shell uname -n) && $(MAKE) iam
	cd k && $(MAKE) update
	$(MAKE) ready

down:
	bin/make-k3s down

healthy:
	while ! app wait argocd/$(env)-cluster --health; do sleep 5; done

ready:
	while ! kubectl --context $(env) rollout -n kube-system status deployment pod-identity-amazon-eks-pod-identity-webhook | bat; do sleep 10; done
	-kubectl --context $(env) rollout -n external-secrets restart deployment | bat
	-kubectl --context $(env) rollout -n karpenter restart deployment | bat

.PHONY: cache
cache:
	cd cache && $(MAKE) up
	cd k && $(MAKE) cache
	cd c && $(MAKE) cache

k3s-recreate:
	-bin/make-k3s down
	$(MAKE) up

tailscale-kubeconfig:
	-kubectl config delete-context $(env)
	-kubectl config delete-context $(env)-$(proxy)
	tailscale configure kubeconfig $(env)-$(proxy) | bat
	kubectl config rename-context $(env)-$(proxy).$(shell tailscale cert 2>&1 | grep 'use ' | cut -d'"' -f2 | cut -d. -f2-) $(env) | bat

hello:
	test "$$(pass hello)" == world

token:
	@kubectl create token headlamp-admin -n headlamp

trunk:
	cd && curl https://get.trunk.io -fsSL | bash -s -- -y
	cd && $(MAKE) trunk

ssh-config:
	coder config-ssh --yes -o "RemoteForward /home/ubuntu/.gnupg/S.gpg-agent $${HOME}/.gnupg/S.gpg-agent.extra"

reboot:
	sync
	($(MAKE) down & sleep 60; sudo rm -rf /var/lib/rancher; sudo reboot) &

activate:
	sudo rm -rf /tmp/ssm
	mkdir -p /tmp/ssm
	curl -sSL https://amazon-ssm-$(region).s3.$(region).amazonaws.com/latest/debian_amd64/ssm-setup-cli -o /tmp/ssm/ssm-setup-cli
	sudo chmod +x /tmp/ssm/ssm-setup-cli
	sudo /tmp/ssm/ssm-setup-cli -override -register -activation-code "$(actcode)" -activation-id "$(actid)" -region "$(region)"
	sudo rm -rf /tmp/ssm

create-activation:
	@b agent b exec defn-org aws ssm create-activation --default-instance-name $(name) --iam-role service-role/AmazonEC2RunCommandRoleForManagedInstances --registration-limit 1 --region $(region)  --expiration-date "$$(date -d "+1 day" +"%Y-%m-%dT00:00:00")" | jq -r '"make activate region=$(region) actid=\(.ActivationId) actcode=\(.ActivationCode)"'work ?= /home/ubuntu/m/demo

