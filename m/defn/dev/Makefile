SHELL := /bin/bash

build: # Generate CRDs using cue-gen
	buf generate

make_%:
	./$@.sh