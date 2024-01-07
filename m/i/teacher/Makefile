SHELL := /bin/bash

build:
	$(MAKE) coder

fmt: # Format packer configs
	packer fmt -write=true .

hello:
	test "$$(pass hello)" == world

%:
	$(MAKE) hello
	packer init $@.pkr.hcl
	b exec defn-org env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl
