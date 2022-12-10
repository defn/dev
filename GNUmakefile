SHELL := /bin/bash

nix-ignore:
	@true

menu: # This menu
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' $(shell ls -d GNUmakefile Makefile.* 2>/dev/null)

-include Makefile.site
