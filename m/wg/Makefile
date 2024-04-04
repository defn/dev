default:
	$(MAKE) build

-include ../common/Makefile.coder

build:
	b build

server: build
	../bazel-bin/wg/wg_/wg server

client: build
	../bazel-bin/wg/wg_/wg client
