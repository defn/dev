SHELL := /bin/bash

build:
	$(MAKE) aws

aws:
	env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl

fmt: # Format packer configs
	packer fmt -write=true .