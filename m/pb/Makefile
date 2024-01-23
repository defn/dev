host ?= $(shell uname -n)
playbook ?= playbooks/demo.yaml

play:
	ansible-playbook -i ./inventory.sh -l "$(host)" "$(playbook)"