SHELL := /bin/bash

menu: # This menu
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' $(shell ls -d GNUmakefile Makefile.* 2>/dev/null)

-include Makefile.site

update: # Update git repo and cue libraries
	git pull
	hof mod vendor cue
	@echo; echo 'To update configs: c config'; echo
