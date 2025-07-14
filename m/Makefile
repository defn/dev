# Install project dependencies
# Dependencies: make command
# Outputs: Executes install target
dzefault:
	$(MAKE) install

-include common/Makefile.coder

timeout ?= 2592000

env ?= $(DFD_PREFIX)-$(DFD_OWNER)-$(DFD_NAME)

name ?= local
domain ?= defn.run
listen ?= 127.0.0.1:3443

proxy ?= proxy3

# Install npm dependencies quietly
# Dependencies: npm command, package.json file
# Outputs: Installed npm dependencies in node_modules directory
install:
	npm -q --no-update-notifier --no-audit install

# Sync home directory configuration
# Dependencies: make command, home directory Makefile
# Outputs: Executes sync target in home directory
sync:
	cd && $(MAKE) sync

work ?=
# Open VS Code dev container or start bash session for macOS development
# Dependencies: REMOTE_CONTAINERS_IPC environment variable, direnv command, .direnv/bin/nix-direnv-reload script, bash command, code command, perl command, xxd command, pwd command
# Outputs: Allowed direnv configuration and started bash session (if in container), or opened VS Code dev container (if not in container)
dev-macos:
# keep this for the folder-uri opening technique
	@if test -n "$${REMOTE_CONTAINERS_IPC:-}"; then \
		direnv allow; \
		bash .direnv/bin/nix-direnv-reload 2>/dev/null || true; \
		bash; \
	else \
		code --folder-uri "vscode-remote://dev-container+$$(pwd | perl -pe 's{\s+$$}{}' | xxd -p)/home/ubuntu/m/$(work)" 2>/dev/null; \
	fi

# Build all components and format code
# Dependencies: MODULES.bazel.lock file, make command, trunk binary
# Outputs: Removed MODULES.bazel.lock, executed regen and build targets, formatted code with trunk
all:
	rm -f MODULES.bazel.lock
	$(MAKE) regen build
	$(MAKE) trunk
	trunk fmt

# Build the project using Bazel
# Dependencies: b binary, Bazel BUILD files
# Outputs: Built project artifacts via Bazel
build:
	b build

# Build and push Docker image
# Dependencies: bazel-bin/cmd/cli/cli_/cli binary, docker command, Dockerfile, $(tag) variable
# Outputs: Copied cli binary to cli.bin, built Docker image with $(tag), removed cli.bin, pushed image to registry
image:
	cp -f bazel-bin/cmd/cli/cli_/cli cli.bin
	docker build -t $(tag) .
	rm -f cli.bin
	docker push $(tag)

# List files that are either in Bazel or Git but not both
# Dependencies: bazel command, git command, grep command, sort command, uniq command, awk command
# Outputs: List of files that exist in either Bazel build or Git but not both
todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

# Start CI agent without Git credentials
# Dependencies: env command, make command, AGENT variable
# Outputs: Executed ci_inner target with GIT_ASKPASS and GIT_SSH_COMMAND environment variables unset
ci: 
	env -u GIT_ASKPASS -u GIT_SSH_COMMAND $(MAKE) ci_inner AGENT=${AGENT}

# Start Buildkite agent with configured paths and timeout
# Dependencies: mkdir command, buildkite-agent binary, BUILDKITE_AGENT_TOKEN variable, $(timeout) variable, AGENT variable
# Outputs: Created buildkite agent and plugins directories, started Buildkite agent with specified configuration
ci_inner:
	mkdir -p ~/work/buildkite-{agent,plugins}${AGENT}
	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=$(timeout) buildkite-agent start \
		--build-path ~/work/buildkite-agent${AGENT} \
		--plugins-path ~/work/buildkite-plugins${AGENT} \
		--token "$(BUILDKITE_AGENT_TOKEN)"

# Build website documentation and commit changes
# Dependencies: defn/dev/www directory with Makefile, make command, git command, docs directory
# Outputs: Built website documentation, added docs to git staging, committed docs changes
ci_web:
	cd defn/dev/www && $(MAKE) build
	cd && git add docs
	git commit -m 'update docs' || true

# Clean Coder postgres data for teacher setup
# Dependencies: ~/Library/Application Support/coderv2/postgres directory (macOS)
# Outputs: Removed Coder postgres data directory
teacher-clean:
	rm -rf ~/Library/App*/coderv2/postgres

# Initialize Coder with admin user for teacher setup
teacher-init:
	coder login https://$(shell tailscale cert 2>&1 | grep 'For domain'  | cut -d'"' -f2) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

# Initialize Coder for class environment with admin user
class-init:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain) --first-user-username="admin" --first-user-email="iam+admin@defn.sh" --first-user-password="Admin123456789,,," --first-user-trial=false

# Start teacher Coder server (kills existing postgres first)
teacher: 
	pkill postgres || true
	$(MAKE) dev_inner name=$(name)

# Start Coder server with OAuth GitHub integration and TLS
dev_inner:
	coder server --oauth2-github-allow-signups \
		--enable-terraform-debug-mode \
		--oauth2-github-allowed-orgs $(coder_oauth2_github_allowed_orgs) --oauth2-github-allowed-teams $(coder_oauth2_github_allowed_teams) \
		--oauth2-github-client-id $(coder_oauth2_github_client_id_$(name)) --oauth2-github-client-secret $(coder_oauth2_github_client_secret_$(name)) \
		--access-url "https://coder.$(name).$(domain)" --wildcard-access-url "*.$(name).$(domain)" \
		--derp-force-websockets \
		--tls-enable \
		--tls-cert-file ~/m/coder/live/$(name).$(domain)/fullchain.pem \
		--tls-key-file ~/m/coder/live/$(name).$(domain)/privkey.pem \
		--tls-address $(listen)

# Install CDKTF dependencies and regenerate code
# Dependencies: npm command, package.json file, tf directory, npx command, cdktf binary, make command
# Outputs: Installed npm dependencies, downloaded CDKTF providers, regenerated code
cdktf:
	npm -q --no-update-notifier --no-audit install
	cd tf && npx cdktf get
	$(MAKE) regen

# Upgrade Go dependencies and regenerate code
upgrade:
	$(MAKE) go-upgrade
	$(MAKE) regen
	#npm -q --no-update-notifier --no-audit install
	#npm -q --no-update-notifier --no-audit upgrade
	#npm -q --no-update-notifier --no-audit outdated

# Upgrade Go modules in all directories with go files
go-upgrade:
	set -x; go get -u $$(git ls-files | grep 'go$$' | perl -pe 's{[^/]+$$}{\n}' | sort -u | runmany 4 1 'echo ./$$1' | grep -v /demo/ | grep -v /cv/)

# Update infrastructure by regenerating CDKTF
update:
# cd tf && env SYNTH_HCL_OUTPUT=true cli infra && terraform fmt cdktf.out/stacks/*
	$(MAKE) cdktf

# Regenerate Go dependencies and Bazel BUILD files
# Dependencies: mark binary, go command, git command, perl command, runmany script, bazel command, b binary, go.mod files
# Outputs: Mark log entry, updated Go module dependencies, tidied go.mod files, tidied Bazel modules, regenerated Bazel BUILD files
regen:
	@mark gazelle
	go get $$(git ls-files | grep 'go$$' | perl -pe 's{[^/]+$$}{\n}' | sort -u | runmany 4 1 'echo ./$$1' | grep -v /cv/)
	go mod tidy
	bazel mod tidy
	b pass run //:gazelle

# Login to Coder instance
coder-login:
	coder login https://coder.$(env).$(GIT_AUTHOR_NAME).$(domain)

# Create Coder admin user and login
coder-admin:
	k exec -n coder -ti deploy/coder -- bash -c 'coder server create-admin-user --email iam+admin@defn.sh --password admin --username admin --postgres-url postgresql://coder:$$(cat ~/.config/coderv2/postgres/password)@localhost:$$(cat ~/.config/coderv2/postgres/port)/?sslmode=disable'
	$(MAKE) coder-login
	cd coder/pod && $(MAKE) push

# Create self-signed certificate for environment
self-cert:
	step certificate create --subtle --insecure --no-password --force --profile self-signed $(env) $(env).crt $(env).key

# One-time setup: add helm repo, push all, setup cache, and update environment
once:
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification
	cd k && $(MAKE) all-push
	cd c && $(MAKE) cache
	cd k && $(MAKE) update env=$(env)

# Setup virtual cluster context and ArgoCD config
vc-context:
	env KUBECONFIG=$$HOME/.kube/config-in-cluster vcluster connect vcluster -n $(env) --server=$$(env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl get -n $(env) svc vcluster -o json | jq -r '.spec.clusterIP'):443 --update-current=false --kube-config-context-name $(env)-cluster --kube-config "$$HOME/.kube/config"
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd

# Add virtual cluster to ArgoCD
vc-argocd:
	-env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core rm $(env)-cluster --yes
	env KUBECONFIG=$$HOME/.kube/config-in-cluster:$$HOME/.kube/config argocd cluster --kube-context dfd --core add $(env)-cluster --yes --upsert

# Setup complete virtual cluster with ArgoCD integration
vc:
	$(MAKE) vc-context
	chmod 0600 ~/.kube/config
	$(MAKE) vc-argocd
	cp $$HOME/.kube/config-in-cluster $$HOME/.kube/config.argocd
	if env KUBECONFIG=$$HOME/.kube/config-in-cluster kubectl apply -f e/$(env)-cluster.yaml; then cd k && env KUBECONFIG=$$HOME/.kube/config-in-cluster $(MAKE) update env=$(env); fi

# Setup developer experience environment with ArgoCD namespace and cache repo
devx:
	cp /home/ubuntu/.kube/config /home/ubuntu/.kube/config.argocd
	env KUBECONFIG=$$HOME/.kube/config.argocd k config set-context --current --namespace argocd
	app repo add cache.$(domain):5000 --type helm --name cache --enable-oci --insecure-skip-server-verification

# Start k3s cluster and setup IAM and updates
up:
	bin/make-k3s up
	cd c/$(shell uname -n) && $(MAKE) iam
	cd k && $(MAKE) update
	$(MAKE) ready

# Stop k3s cluster
down:
	bin/make-k3s down

# Wait for ArgoCD cluster to become healthy
healthy:
	while ! app wait argocd/$(env)-cluster --health; do sleep 5; done

# Wait for cluster to be ready and restart key deployments
ready:
	while ! kubectl --context $(env) rollout -n kube-system status deployment pod-identity-amazon-eks-pod-identity-webhook | bat; do sleep 10; done
	-kubectl --context $(env) rollout -n external-secrets restart deployment | bat
	-kubectl --context $(env) rollout -n karpenter restart deployment | bat

# Setup cache infrastructure
# Dependencies: cache directory with Makefile, k directory with Makefile, c directory with Makefile, make command
# Outputs: Started cache infrastructure, configured cache in k and c directories
.PHONY: cache
cache:
	cd cache && $(MAKE) up
	cd k && $(MAKE) cache
	cd c && $(MAKE) cache

# Recreate k3s cluster from scratch
k3s-recreate:
	-bin/make-k3s down
	$(MAKE) up

tailscale-kubeconfig:
	-kubectl config delete-context $(env)
	-kubectl config delete-context $(env)-$(proxy)
	tailscale configure kubeconfig $(env)-$(proxy) | bat
	kubectl config rename-context $(env)-$(proxy).$(shell tailscale cert 2>&1 | grep 'use ' | cut -d'"' -f2 | cut -d. -f2-) $(env) | bat

# Test that password store contains expected hello value
hello:
	test "$$(pass hello)" == world

# Create authentication token for Headlamp dashboard
token:
	@kubectl create token headlamp-admin -n headlamp

# Install and setup Trunk code quality tools
trunk:
	cd && curl https://get.trunk.io -fsSL | bash -s -- -y
	cd && $(MAKE) trunk

# Configure SSH for Coder with GPG agent forwarding
ssh-config:
	coder config-ssh --yes -o "RemoteForward /home/ubuntu/.gnupg/S.gpg-agent $${HOME}/.gnupg/S.gpg-agent.extra"

# Cleanly reboot system after stopping k3s and removing Rancher data
reboot:
	sync
	($(MAKE) down & sleep 60; sudo rm -rf /var/lib/rancher; sudo reboot) &

# Register instance with AWS Systems Manager using activation code
activate:
	sudo rm -rf /tmp/ssm
	mkdir -p /tmp/ssm
	curl -sSL https://amazon-ssm-$(region).s3.$(region).amazonaws.com/latest/debian_amd64/ssm-setup-cli -o /tmp/ssm/ssm-setup-cli
	sudo chmod +x /tmp/ssm/ssm-setup-cli
	sudo /tmp/ssm/ssm-setup-cli -override -register -activation-code "$(actcode)" -activation-id "$(actid)" -region "$(region)"
	sudo rm -rf /tmp/ssm

create-activation:
	@b agent b exec defn-org aws ssm create-activation --default-instance-name $(name) --iam-role service-role/AmazonEC2RunCommandRoleForManagedInstances --registration-limit 1 --region $(region)  --expiration-date "$$(date -d "+1 day" +"%Y-%m-%dT00:00:00")" | jq -r '"make activate region=$(region) actid=\(.ActivationId) actcode=\(.ActivationCode)"'work ?= /home/ubuntu/m/demo

# Generate CUE inventory of all files in the repository
# Dependencies: git command, sed command, perl command, sort command, cue command
# Outputs: Generated m.cue file with inventory of all repository files, formatted CUE file, validated CUE configuration
inventory:
	(echo package m; git ls-files | sed "s#^#/#" | perl -pe 's{^}{files: "}; s{$$}{": #file}; s{(\S+)/}{$$1": "}' | env LANG=C sort) > m.cue
	cue fmt 
	cue eval -c >/dev/null
