default:
	$(MAKE) build

-include ../../common/Makefile.coder
-include ../../common/Makefile.bazel

image ?= quay.io/defn/dev:latest-hook-example

build: build-image build-operator
	@true

build-operator:
	b build

build-image:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --image=$(image)
	docker pull $(image)
