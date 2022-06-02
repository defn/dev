SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' GNUmakefile

-include Makefile.site

update:
	git pull
	hof mod vendor cue
