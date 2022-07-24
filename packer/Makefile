SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

do: # Build DigitalOcean image
	env DIGITALOCEAN_TOKEN="$$(pass DIGITALOCEAN_TOKEN)" packer build -color=true -timestamp-ui=true $@.pkr.hcl

fmt: # Format packer configs
	packer fmt -write=true .
