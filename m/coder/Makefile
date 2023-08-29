template := $(shell basename $(shell pwd))

push:
	tf fmt
	tf docs
	ls -d mod/*/ | runmany 'cd $$1 && tf fmt && tf docs'
	tar -cvh --exclude .terraform . | coder templates push -y --create -d - "$(template)"

build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build

reset:
	 earthly prune --reset

image:
	cd base && $(MAKE) build
	cd k3d && $(MAKE) build
	cd pod && $(MAKE) build

provider ?= pod

name ?= $(shell basename $(shell pwd))
dir ?= $(shell pwd)
rev ?= $(shell git branch --show-current)

up:
	@bash -c "time $(MAKE) up-inner"

up-inner:
	coder create --yes --template pod --parameter workdir=$(dir),source_rev=$(rev),provider=$(provider),docker_image=169.254.32.1:5000/dfd,cpu=1,memory=1,nix_volume_size=40 "$(name)"
	@echo
	@while true; do if curl -sSL $$(cat /home/ubuntu/.config/coderv2/url)/api/v2/users/$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1)/workspace/$(name) -H "Coder-Session-Token: $$(cat /home/ubuntu/.config/coderv2/session)" | jq -r '.latest_build.resources[].agents[].apps[] | select(.display_name == "code-server") | .health' | grep healthy; then break; fi; date; sleep 5; done
	@open "$$(curl -sSL $$(cat /home/ubuntu/.config/coderv2/url)/api/v2/debug/health -H "Coder-Session-Token: $$(cat /home/ubuntu/.config/coderv2/session)" | jq -r '.access_url.access_url' | sed "s#//#//cs--main--$(name)--$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1)--#")?folder=$(dir)"

down:
	coder delete --yes "$(name)" || true
