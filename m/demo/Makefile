workdir ?= /home/ubuntu/m/demo

shell:
	@if test -n "$${REMOTE_CONTAINERS_IPC:-}"; then \
		direnv allow; \
		bash .direnv/bin/nix-direnv-reload 2>/dev/null || true; \
		bash; \
	else \
		docker ps -q -a --filter label=devcontainer.config_file=$$(pwd)/.devcontainer/devcontainer.json | runmany 'docker rm -f $$1 2>/dev/null'; \
		code --folder-uri "vscode-remote://dev-container+$$(pwd | perl -pe 's{\s+$$}{}' | xxd -p)$(workdir)" 2>/dev/null; \
	fi

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
