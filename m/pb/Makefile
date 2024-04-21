second = $(word 2, $(subst -, ,$@))

pb ?= 
limit ?=
check ?=

ifdef limit
opt_limit = -l "$(limit)"
endif

ifdef check
opt_check = --check --diff
endif

opt ?= $(opt_limit) $(opt_check)

build:
	cue fmt $$(git ls-files | grep 'cue$$')
	rm -f playbooks/*.yaml
	rm -rf roles/*/tasks
	cue export --out json -e fs | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | ../c/decode_base64.py 

report:
	@echo; (cd dump && cue export --out json) | jq -r '.host | to_entries[] | .key as $$host | .value as $$facts | $$facts.ansible_processor | "\($$host) \($$facts.ansible_processor_nproc) \(.[2])"' | talign 2

$(HOME)/.local/bin/ansible-playbook:
	pipx install --force --include-deps ansible

playbooks/*.yaml: playbooks.cue
	$(MAKE) build

%: $(HOME)/.local/bin/ansible-playbook playbooks/%.yaml
	$(HOME)/.local/bin/ansible-playbook $(opt) "playbooks/$@.yaml"

local: playbooks/*.yaml
	$(MAKE) $(pb) opt="-i inventory/packer.ini -c local $(opt)"

check: playbooks/*.yaml
	$(MAKE) $(pb) opt="-i inventory/packer.ini -c local $(opt) --check --diff"
