ignore:
	@true

update:
	$(MAKE) bazel-ignore
	$(MAKE) update-repos

watch:
	ibazel build //...

build:
	bazel build //...

bazel-ignore:
	echo tf > .bazelignore
	echo node_modules >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1.direnv}' | sort >> .bazelignore
	git ls-files | grep flake.nix | perl -pe 's{(/?)flake.nix}{\1result}' | sort >> .bazelignore
	git ls-files | grep cue.mod | perl -pe 's{(cue.mod).*}{$$1}' | sort -u >> .bazelignore
	echo cmd/cli/proto >> .bazelignore

update-repos:
	bazel run //:gazelle -- update-repos $$(git ls-files | grep -v tf/terraform | grep 'go.mod' | runmany 'echo -from_file=$$1')

nix-build-all:
	git ls-files | grep flake.nix | perl -pe 's{/?flake.nix}{}' | runmany 'mark $$1; cd ./$$1 && nix build'

cdktf-get:
	npm install
	npx cdktf get
