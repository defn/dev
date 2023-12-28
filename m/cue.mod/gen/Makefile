SHELL := /bin/bash

update:
	b build
	b run outputs_k8s_cue_schema__update
	tar xvfz cue.mod/gen.tgz
	rm -f cue.mod/gen.tgz

get: # get k8s go packages
	$(MAKE) make_update_k8s_go

make_%:
	./$@.sh