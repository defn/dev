template := $(shell basename $(shell pwd))

push:
	tf fmt
	tf docs
	ls -d mod/*/ | runmany 'cd $$1 && tf fmt && tf docs'
	tar -cvh --exclude .terraform . | coder templates push -y --create -d - "$(template)"

workspace ?= $(shell basename $(shell pwd))
dir ?= $(shell pwd)
rev ?= $(shell git branch --show-current)

class:
	@bash -c "time $(MAKE) up-inner"

up-inner:
	# json.latest_build.resources[4].agents[0].apps[0].slug = "code-server"
	$(MAKE) down || true
	$(MAKE) up-create
	@echo
	@while true; do if curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/users/$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1)/workspace/$(workspace) -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep ^healthy; then break; fi; date; sleep 5; done
	@set -x; open "$$(curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/debug/health -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '.access_url.access_url' | sed "s#//#//cs--main--$(workspace)--$$(coder list |tail -1 | awk '{print $$1}' | cut -d/ -f1).#")?folder=$(shell echo $(dir) | sed 's#$(HOME)#/home/ubuntu#')"

up-restart:
	coder restart --yes "$(workspace)"

up-create:
	coder create --yes --template class --parameter workdir=$(dir),source_rev=$(rev),prefix=coder,vcluster=1,provider=pod,docker_image=cache.defn.run:5000/dfd:class-buildkite-latest,cpu=1,memory=1,nix_volume_size=100 "$(workspace)"

down:
	coder delete --yes "$(workspace)"
