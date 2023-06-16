SHELL := /bin/bash

build:
	$(MAKE) check
	$(MAKE) clean
	$(MAKE) gen
	$(MAKE) yaml
	$(MAKE) add

check:
	cue eval -c >/dev/null

clean:
	rm -f ../e/*/*.yaml
	rm -f ../k/*/kustomization.yaml ../k/*/resource-*.yaml ../k/*/patch-*.yaml
	rm -f ../r/*/main.yaml

add:
	git add -u ../e ../k && git add ../e ../k
	git add -u ../r && git add ../r

gen:
	cue cmd gen

yaml:
	runmany 4 'echo $$1; (cd ../k/$$1 && echo && pwd && rm -rf charts local && mkdir -p ../../r/$$1 && kustomize localize . local && kustomize build --enable-helm local > ../../r/$$1/main.yaml && rm -rf charts local/charts) || (echo "ERROR: $$1" && true)' < <(cd ../k && ls -d */)