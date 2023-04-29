eHELL := /bin/bash

check:
	cue fmt
	cue eval -c >/dev/null

gen:
	$(MAKE) check
	find ../e/ -name '*.yaml' | xargs rm -f
	rm -f ../r/*/main.yaml
	rm -f ../k/*/kustomization.yaml
	rm -f ../k/*/resource-*.yaml
	rm -f ../k/*/patch-*.yaml
	rm -f ../misc/tf/*/*.tf.json
	c gen
	git add ../e ../k ../misc/tf
	git add ../e ../k ../misc/tf

regen:
	$(MAKE) gen
	cd ../k && for a in */; do echo $$a; done | runmany 4 'echo $$1; (cd ../k/$$1 && echo && pwd && rm -rf charts local && mkdir -p ../../r/$$1 && kustomize localize . local && kustomize build --enable-helm local > ../../r/$$1/main.yaml && rm -rf charts local/charts) || (echo "ERROR: $$1" && true)'
	find ../r/ ../k/ -name charts | xargs rm -rf
	git add ../k/
	git add -u ../k/

ping-egg:
	kubectl patch terraform egg --type json -p '[ { "op": "replace", "path": "/spec/outputsToOmit/0", "value": "'$$RANDOM'" } ]'

ping-chicken:
	kubectl patch terraform chicken --type json -p '[ { "op": "replace", "path": "/spec/outputsToOmit/0", "value": "'$$RANDOM'" } ]'
