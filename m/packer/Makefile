SHELL := /bin/bash

build:
	$(MAKE) k3d/bin/k3d

update:
	true

aws: k3d/bin/k3d
	env AWS_VAULT= aws-vault exec gyre-ops-sso -- packer build -color=true -timestamp-ui=true $@.pkr.hcl

k3d/bin/k3d:
	-git clone https://github.com/amanibhavam/k3d
	cd k3d && make ci-setup build && chmod 755 bin/k3d

fmt: # Format packer configs
	packer fmt -write=true .