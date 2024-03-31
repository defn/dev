up:
	tilt up

build:
	cd cfg && $(MAKE)

test:
	$(MAKE) install
	$(MAKE) whoami
	$(MAKE) plan

install:
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	trunk install
	npm install
	cd cfg && go get && go mod tidy

whoami:
	@PATH=$$PATH:../../bin runmany 'aws --profile $$1-sso sts get-caller-identity | bat' $$(cd cfg && cue eval -e input.accounts | jq -r '.[]')

plan:
	@PATH=$$PATH:../../bin runmany 'cd $$1 && tf plan | bat' stacks/*/
