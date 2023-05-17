ignore:
	@true

up:
	nix develop --command tilt up --stream --port=0

get:
	npm install
	npx cdktf get

upgrade:
	go get -u  ./...
	go mod tidy

update:
	go mod tidy
	$(MAKE) bazel-ignore

regen:
	cd a && buf generate && find . -nam 'BUILD.bazel' | xargs rm -f
	$(MAKE) update-repos
	cd a && $(MAKE)

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

image:
	earthly +build

ci:
	$(MAKE) image
	docker run --rm -ti -v nix-cache:/cache meh "make build"

shell:
	docker run --rm -ti -v nix-data:/nix -v nix-cache:/cache meh "make build; bash -il"
