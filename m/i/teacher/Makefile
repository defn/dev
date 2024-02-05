SHELL := /bin/bash

build:
	$(MAKE) coder

fmt: # Format packer configs
	packer fmt -write=true .

hello:
	test "$$(pass hello)" == world

all:
	$(MAKE) class
	$(MAKE) class-buildkite-latest
	$(MAKE) buildkite

latest:
	$(MAKE) class-buildkite-latest

reset:
	@echo --- pruning
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	cd ../../cache && docker compose down && $(MAKE) up
	this-prune

root:
	earthly --ci --no-cache --no-output --push +root

buildkite:
	@echo --- earthly
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	docker ps || sudo docker ps
	earthly --ci --push --no-output +buildkite

class:
	@echo --- earthly 
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	earthly --ci --push --no-output +class

class-buildkite-latest:
	@echo --- earthly
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	earthly --ci --push --no-output +class-buildkite-latest

%:
	$(MAKE) hello
	packer init $@.pkr.hcl
	b exec defn-org env AWS_REGION=us-west-2 packer build -color=true -timestamp-ui=true $@.pkr.hcl
