build:
	$(MAKE) -j 2 buildkite aws

buildkite:
	earthly --push --no-output +buildkite

aws:
	earthly --push --no-output +aws
