default:
	$(MAKE) build

-include ../common/Makefile.coder

build:
	b watch

server: ../bazel-bin/wg/wg_/wg
	../bazel-bin/wg/wg_/wg server

client: ../bazel-bin/wg/wg_/wg
	../bazel-bin/wg/wg_/wg client
