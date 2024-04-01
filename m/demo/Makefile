profile ?= demo-org

default:
	$(MAKE) build

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

init-upgrade:
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'cd $$1 && tf upgrade | bat' stacks/*/

locks:
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'cd $$1 && tf locks| bat' stacks/*/

plan:
	@unset AWS_VAULT && PATH=$$PATH:../../bin runmany 'cd $$1 && tf plan | bat' stacks/*/

login:
	@open "https://signin.aws.amazon.com/oauth?Action=logout&redirect_uri=$$(aws-vault login $(profile)-sso-source -s | sed 's#://#://us-east-1.#' | python -c 'import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read().strip()))')"
	
coder:
	while true; do $(MAKE) coder-inner; sleep 5; done
	
coder-inner:
	pkill trunk || true
	$(MAKE) -j 2 code-server

tilt:
	pkill trunk || true
	$(MAKE) -j 2 tilt-run tilt-open

tilt-run:
	tilt up --stream

tilt-open:
	while true; do if curl -s -o /dev/null 127.0.0.1:10350; then break; fi; sleep 1; done
	open http://127.0.0.1:10350

code-server:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done
