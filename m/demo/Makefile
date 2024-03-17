build:
	cd cfg && $(MAKE)

install:
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	trunk install
	npm install
	cd cfg && go get && go mod tidy

test:
	$(MAKE) whoami
	$(MAKE) plan

whoami:
	@PATH=$$PATH:../../bin runmany 'aws --profile $$1-sso sts get-caller-identity | bat' $$(cd cfg && cue eval -e input.accounts | jq -r '.[]')

plan:
	@PATH=$$PATH:../../bin runmany 'cd $$1 && tf plan | bat' stacks/*/

name ?=
homedir ?= $(shell pwd)
remote ?= ubuntu@macmini
command ?= make coder-ssh-devcontainer
arch ?= amd64
os ?= linux
template ?= coder-defn-ssh-template

recreate:
	$(MAKE) clean create name=$(name)

create:
	coder delete $(name) --yes 2>/dev/null || true
	coder create $(name) --template $(template) --parameter arch=$(arch),os=$(os),homedir=$(homedir),remote=$(remote),command="$(command)" --yes
	$(MAKE) open name=$(name)

open:
	@while true; do if curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/users/$$(coder list | tail -1 | awk '{print $$1}' | cut -d/ -f1)/workspace/$(name) -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep -q ^healthy; then break; fi; date; sleep 5; done
	@open "$$(curl -sSL $$(cat $$HOME/.config/coderv2/url)/api/v2/debug/health -H "Coder-Session-Token: $$(cat $$HOME/.config/coderv2/session)" | jq -r '.access_url.access_url')/@$$(coder list | tail -1 | awk '{print $$1}' | cut -d/ -f1)/$(name).main/apps/cs/?folder=$(shell echo $(homedir) | sed 's#$(HOME)#/home/ubuntu#')"

clean:
	docker ps -q -a --filter label=devcontainer.config_file=$$(pwd)/.devcontainer/devcontainer.json | runmany 'docker rm -f $$1 2>/dev/null'
