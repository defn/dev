default:
	$(MAKE) build

-include ../common/Makefile.coder

build:
	b watch

../bazel-bin/wg/wg_/wg: build
	@true

server:
	../bazel-bin/wg/wg_/wg server

client:
	../bazel-bin/wg/wg_/wg client
