SHELL := /bin/bash

build:
	cue eval --out json -e html | jq -r . > tutorial.html

list:
	$(MAKE) list_vendor_updates

update:
	$(MAKE) update_flakes

upgrade:
	n upgrade && n all update pkg deps
	n upgrade && n all update pkg deps || true

%:
	./make_$@.sh
	@echo