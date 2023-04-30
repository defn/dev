ignore:
	@true

get:
	npm install
	npx cdktf get

update:
	go get -u  ./...
	go mod tidy
	$(MAKE) bazel-ignore

regen:
	$(MAKE) update-repos

build:
	bazel build //...

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
	bazel run //:gazelle -- update-repos $$(git ls-files | grep -v tf/terraform | grep 'go.mod' | runmany 'echo -from_file=$$1')
	bazel run //:gazelle

nix-build-all:
	git ls-files | grep flake.nix | perl -pe 's{/?flake.nix}{}' | runmany 'mark $$1; cd ./$$1 && nix build'
