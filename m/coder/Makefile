template := $(shell basename $(shell pwd))

build:
	cue eval --out json -e html | jq -r . > tutorial.html

run:
	$(MAKE) init
	bash -c 'eval "$$(direnv hook bash)"; _direnv_hook; $(MAKE) run-inner'

run-inner:
	echo screen -S tilt -d -m tilt up --stream

push:
	tf fmt
	tf docs
	ls -d mod/*/ | runmany 'cd $$1 && tf fmt && tf docs'
	tar -cvh --exclude .terraform . | coder templates push -y --create -d - "$(template)"

image:
	earthly --push --no-output +buildkite
	earthly --push --no-output +build

reset:
	 earthly prune --reset

workspace ?= $(shell basename $(shell pwd))
dir ?= $(shell pwd)
rev ?= $(shell git branch --show-current)

up:
	@bash -c "time $(MAKE) up-inner"

up-inner:
	# json.latest_build.resources[4].agents[0].apps[0].slug = "code-server"
	$(MAKE) up-restart || $(MAKE) up-create
	@echo
	@while true; do if curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/users/$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1)/workspace/$(workspace) -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep ^healthy; then break; fi; date; sleep 5; done
	@set -x; open "$$(curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/debug/health -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '.access_url.access_url' | sed "s#//#//cs--main--$(workspace)--$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1).#")?folder=$(shell echo $(dir) | sed 's#$(HOME)#/home/ubuntu#')"

up-restart:
	coder restart --yes "$(workspace)"

up-create:
	coder create --yes --template pod --parameter workdir=$(dir),source_rev=$(rev),provider=pod,docker_image=cache.defn.run:5000/dfd,cpu=1,memory=1,nix_volume_size=40 "$(workspace)"

down:
	coder delete --yes "$(workspace)" || true

init:
	direnv allow
	bash -c 'eval "$$(direnv hook bash)"; _direnv_hook'
	for a in vscodevim.vim golang.Go bazelbuild.vscode-bazel; do code serve-local --force --install-extension $$a; done

login:
	coder login https://coder.dev.amanibhavam.defn.run