all:
	$(MAKE) class
	$(MAKE) class-latest
	$(MAKE) class-buildkite-latest

reset:
	@echo --- pruning
	cd ../../cache && docker compose down && $(MAKE) up
	this-prune
	@echo --- base
	cd ../base && $(MAKE)
	$(MAKE) buildkite

class:
	@echo --- earthly 
	earthly --ci --push --no-output +class

class-latest:
	@echo --- earthly
	earthly --ci --push --no-output +class-latest

class-buildkite-latest:
	@echo --- earthly
	earthly --ci --push --no-output +class-buildkite-latest

buildkite:
	@echo --- earthly
	earthly --ci --push --no-output +buildkite
