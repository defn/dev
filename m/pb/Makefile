coder-server:
	choice="$$(ansible-inventory --list | jq -r '._meta.hostvars | keys | sort | .[]' | fzf --select-1)" && if test -n "$$choice"; then ansible-playbook playbooks/coder-server.yaml -l "$$choice"; fi
