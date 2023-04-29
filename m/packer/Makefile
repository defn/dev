SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

aws: k3d/bin/k3d
	env AWS_VAULT= aws-vault exec gyre-ops-sso -- packer build -color=true -timestamp-ui=true $@.pkr.hcl

k3d/bin/k3d:
	-git clone https://github.com/amanibhavam/k3d
	cd k3d && make ci-setup build && chmod 755 bin/k3d

fmt: # Format packer configs
	packer fmt -write=true .
