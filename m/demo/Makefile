install:
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash | bat; fi
	trunk install | bat
	npm install | bat
	cd cfg && (go get | bat) && (go mod tidy | bat)

test:
	$(MAKE) whoami
	$(MAKE) plan

whoami:
	@runmany 'aws --profile $$1-sso sts get-caller-identity | bat' $$(cd cfg && cue eval -e input.accounts | jq -r '.[]')

plan:
	@runmany 'cd $$1 && tf plan | bat' stacks/*/