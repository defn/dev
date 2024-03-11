install:
	if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	trunk install
	npm install
	cd config && go get && go mod tidy

whoami:
	runmany 'aws --profile $$1-sso sts get-caller-identity' $$(cd config && cue eval -e input.accounts | jq -r '.[]')
