SHELL := /bin/bash

build:
	$(MAKE) ec2

ec2:
	packer init $@.pkr.hcl
	b server defn-org-sso env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl

docker:
	earthly --push +build

fmt: # Format packer configs
	packer fmt -write=true .