SHELL := /bin/bash

build:
	cue eval --out json -e html | jq -r . > tutorial.html

list:
	$(MAKE) list_vendor_updates

update:
	$(MAKE) update_flakes

%:
	./make_$@.sh
	@echo