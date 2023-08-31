timeout ?= 5

build:
	../bin/b pass build //cmd/cli:cli
	cp -f bazel-bin/cmd/cli/cli_/cli /tmp/cli

image:
	cp -f bazel-bin/cmd/cli/cli_/cli cli.bin
	docker build -t $(tag) .
	rm -f cli.bin
	docker push $(tag)

all:
	b pass build //...

todo:
	@(bazel cquery //... --output=files | grep -v ^bazel-; git ls-files .) | sort | uniq -c | grep '^ *1 ' | awk '{print $$2}'

ci:
	env BUILDKITE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT=$(timeout) buildkite-agent start --build-path ~/work/buildkite-agent --plugins-path ~/work/buildkite-plugins --token "$$(pass BUILDKITE_AGENT_TOKEN)"

.PHONY: dev
dev:
# rm -rf ~/Library/App*/coderv2/postgres
	pass hello
	coder server --disable-password-auth --oauth2-github-allow-signups --oauth2-github-allowed-orgs $$(pass coder_oauth2-github-allowed-orgs) --oauth2-github-allowed-teams $$(pass coder_oauth2-github-allowed-teams) --oauth2-github-client-id $$(pass coder_oauth2-github-client-id) --oauth2-github-client-secret $$(pass coder_oauth2-github-client-secret)

cdktf:
	npm install
	npx cdktf get
	$(MAKE) regen

upgrade:
	npm install
	npm outdated
	go get -u  ./...
	go mod tidy

update:
	$(MAKE) bazel-ignore
	$(MAKE) cdktf
	cd tf && cli infra
	cd tf && source ./.envrc && cd stacks && runmany 'cd $$1 && tf upgrade && tf plan' */

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
	k3d cluster delete dfd || true
	sudo rm -rf /nix/k3s /nix/k3s-containerd
	docker rm -f k3d-registry
	this-prune
	bin/make-k3d init
	cd coder && ( $(MAKE) image || $(MAKE) image )

warudo:
	k3d cluster delete dfd || true
	bin/make-k3d
	cd dev && $(MAKE) down up
