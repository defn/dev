buildkite:
	@echo --- earthly
	earthly --ci --push --no-output +buildkite

class-init:
	@echo --- earthly 
	earthly --ci --push --no-output +class-init

class:
	@echo --- earthly
	earthly --ci --push --no-output +class-latest
	earthly --ci --push --no-output +class-buildkite-latest