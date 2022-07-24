SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

do: # Build DigitalOcean image
	packer build -color=false -timestamp-ui=true $@.pkr.hcl

fmt: # Format packer configs
	packer fmt -write=true .
