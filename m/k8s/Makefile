SHELL := /bin/bash

build:
	$(MAKE) make_k8s_cue

make_k8s_cue: # Generate cue schemas for k8s libraries
	b out app_config | ./make_k8s_cue.sh