SHELL := /bin/bash

all:
	env NIX_CONFIG="access-tokens = github.com=$$(b github)" $(MAKE) update upgrade	

list:
	$(MAKE) list_vendor_updates

update:
	$(MAKE) update_flakes

upgrade:
	n upgrade && n all update pkg deps
	n upgrade && n all update pkg deps || true
	git commit --allow-empty -m "finished upgrade"

%:
	./make_$@.sh
	@echo