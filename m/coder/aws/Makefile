SHELL := /bin/bash

build:
	cue eval --out json -e html | jq -r . > tutorial.html

base:
	packer init aws.pkr.hcl
	b exec defn-org-sso env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true base.pkr.hcl

fmt: # Format packer configs
	packer fmt -write=true .