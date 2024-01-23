host ?= $(shell uname -n)
playbook ?= playbooks/demo.yaml

play:
	cue export --out json -e fs | jq -r 'to_entries[] | .key as $$fname | "\($$fname) \(.value | @base64)"' | ../c/decode_base64.py 
	ansible-playbook -i ./inventory.sh -l "$(host)" "$(playbook)"
