SHELL := /bin/bash

list:
	$(MAKE) list_vendor_updates
	@echo

build:
	true	

update:
	$(MAKE) update_flakes

%:
	./make_$@.sh