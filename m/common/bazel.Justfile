# Runs Bazel build
[no-cd]
build:
	@b build

# Runs iBazel watch
[no-cd]
watch:
	@b watch

# json build graph
[no-cd]
json rule:
	@bazel query --noimplicit_deps 'deps({{rule}})' --output streamed_jsonproto | jq .