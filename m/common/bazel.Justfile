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
	@bazel query --noimplicit_deps 'deps({{rule}})' --output streamed_jsonproto | jq -s .

# list source nodes
[no-cd]
source rule:
	#!/usr/bin/env bash
	set -efuo pipefail

	just bazel::json {{rule}} | gron | grep -v rule.attribute | gron -u \
		| jq -r '.[] | .type as $type | (.rule//.sourceFile) | "\($type) \(.name) \(.ruleClass//"") \(if .ruleInput == null then "" else .ruleInput end)"' \
		| grep SOURCE_FILE | grep -v ' @'
