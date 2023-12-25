build:
	$(MAKE) -j 2 buildkite class

buildkite:
	earthly --push --no-output +buildkite

class:
	earthly --push --no-output +class
