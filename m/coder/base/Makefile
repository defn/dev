SHELL := /bin/bash

build:
	$(MAKE) docker

aws:
	packer init $@.pkr.hcl
	b exec defn-org-sso env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl

docker:
	env -u SSH_AUTH_SOCK earthly --push +build

fmt: # Format packer configs
	packer fmt -write=true .