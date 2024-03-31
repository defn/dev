coder:
	pkill trunk || true
	$(MAKE) -j 2 tilt code-server

tilt:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; tilt up; sleep 5; done

code-server:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done

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
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'aws --profile $$1-sso sts get-caller-identity | bat' $$(cd cfg && cue eval -e input.accounts | jq -r '.[]')

init:
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'cd $$1 && tf init | bat' stacks/*/

plan:
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'cd $$1 && tf plan | bat' stacks/*/
