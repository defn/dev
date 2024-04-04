default:
	for h in hook; do cue export --out json -e hooks.$$h.config > hooks/$$h.json; done
	$(MAKE) build

-include ../../common/Makefile.coder
-include ../../common/Makefile.build

image ?= quay.io/defn/dev:latest-hook-example

deploy:
	$(MAKE) chart
