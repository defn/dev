SHELL := /bin/bash

menu: # This menu
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' $(shell ls -d GNUmakefile Makefile.* 2>/dev/null)

-include Makefile.site

update: # Update git repo and cue libraries
	git pull
	hof mod vendor cue
	@echo; echo 'To update configs: c config'; echo

pc: # Install pre-commit via earthly
	earthly +pre-commit --workdir=$(shell pwd)
	tar xfz .cache/pre-commit.tgz
	env PRE_COMMIT_HOME=$(shell pwd)/.cache/pre-commit pre-commit run
