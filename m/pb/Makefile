limit ?= $(shell uname -n)
pb ?= demo
playbook ?= playbooks/$(pb).yaml

build:
	rm -rf playbooks
	cue export --out json -e fs | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | ../c/decode_base64.py 

%:
	@ansible-playbook -l "$(limit)" "playbooks/$@.yaml"
