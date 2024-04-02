default:
	$(MAKE) build

-include ../common/Makefile.coder

game ?= sunny


level:
	cd phaser-editor && $(MAKE) game="$(shell pwd)/$(game)"

sound:
	cd jsfxr && $(MAKE)

pixel:
	cd piskel && $(MAKE)

