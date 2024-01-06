class-init:
	@echo --- pruning
	this-prune
	@echo --- base
	cd ../base && $(MAKE)
	@echo --- earthly 
	earthly --ci --push --no-output +class-init

class:
	@echo --- earthly
	earthly --ci --push --no-output +class-latest

buildkite:
	@echo --- earthly
	earthly --ci --push --no-output +buildkite
	earthly --ci --push --no-output +class-buildkite-latest
