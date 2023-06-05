SHELL := /bin/bash

build:
	$(MAKE) check
	$(MAKE) gen
	$(MAKE) yaml

check:
	cue fmt
	cue eval -c >/dev/null

gen:
	rm -f ../e/*/*.yaml
	rm -f ../k/*/kustomization.yaml
	rm -f ../k/*/resource-*.yaml
	rm -f ../k/*/patch-*.yaml
	c gen
	git add -u ../e ../k
	git add ../e ../k

yaml:
	rm -f ../r/*/main.yaml
	cd ../k && for a in */; do echo $$a; done | runmany 4 'echo $$1; (cd ../k/$$1 && echo && pwd && rm -rf charts local && mkdir -p ../../r/$$1 && kustomize localize . local && kustomize build --enable-helm local > ../../r/$$1/main.yaml && rm -rf charts local/charts) || (echo "ERROR: $$1" && true)'
	git add -u ../r
	git add ../r
