SHELL := /bin/bash

menu: # This menu
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' GNUmakefile

-include Makefile.site

update: # Update git repo and cue libraries
	git pull
	hof mod vendor cue
	@echo; echo 'To update configs: c config'; echo

pc: # Install pre-commit via earthly
	earthly +pre-commit --workdir=$(shell pwd)
	tar xfz .cache/pre-commit.tgz
	pre-commit run
