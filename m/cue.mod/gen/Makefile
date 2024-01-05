SHELL := /bin/bash

update:
	b build
	b run outputs_gen_cue_mod_gen_tgz__copy
	tar xfz cue.mod/gen.tgz
	rm -f cue.mod/gen.tgz

get: # get k8s go packages
	$(MAKE) make_update_k8s_go

meh:
	b build meh_main && b out meh_main

make_%:
	./$@.sh