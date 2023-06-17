SHELL := /bin/bash

build: # Generate cue definitions from k8s go packages
	$(MAKE) make_k8s_cue

update: # Update k8s go packages
	$(MAKE) make_update_k8s_go

make_%:
	./$@.sh