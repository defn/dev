limit ?= $(shell uname -n)
pb ?= demo
playbook ?= playbooks/$(pb).yaml

build:
	cue fmt ./...
	rm -f playbooks/*.yaml
	rm -rf roles
	cue export --out json -e fs | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | ../c/decode_base64.py 

report:
	@echo; (cd dump && cue export --out json) | jq -r '.host | to_entries[] | .key as $$host | .value as $$facts | $$facts.ansible_processor | "\($$host) \($$facts.ansible_processor_nproc) \(.[2])"' | talign 2

$(HOME)/.local/bin/ansible-playbook:
	pipx install --include-deps ansible

%: $(HOME)/.local/bin/ansible-playbook
	@ansible-playbook -l "$(limit)" "playbooks/$@.yaml"
