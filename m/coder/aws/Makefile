SHELL := /bin/bash

build:
	cue eval --out json -e html | jq -r . > tutorial.html

fmt: # Format packer configs
	packer fmt -write=true .

%:
	packer init $@.pkr.hcl
	b exec defn-org-sso env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl
