SHELL := /bin/bash

build:
	$(MAKE) make_clean_generated
	$(MAKE) make_generate_kustomize
	$(MAKE) make_generate_release
	$(MAKE) make_add_generated

make_%:
	./$@.sh