default:
	$(MAKE) build

-include ../../common/Makefile.coder
-include ../../common/Makefile.build

image ?= quay.io/defn/dev:latest-hook-example

deploy:
	$(MAKE) chart
