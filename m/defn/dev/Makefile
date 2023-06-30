SHELL := /bin/bash

build: # Generate CRDs using cue-gen
	cue-gen -f=cue.yaml --crd=true
	buf generate

make_%:
	./$@.sh