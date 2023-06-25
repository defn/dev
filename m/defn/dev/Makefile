SHELL := /bin/bash

build: # Generate CRDs using cue-gen
	$(MAKE) make_crd_cue_gen

update: # Update cue-gen go packages
	$(MAKE) make_update_cue_gen

make_%:
	./$@.sh