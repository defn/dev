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

# List source nodes
[no-cd]
source rule:
	#!/usr/bin/env bash
	set -efuo pipefail

	just bazel::json {{rule}} | gron | grep -v rule.attribute | gron -u \
		| jq -r '.[] | .type as $type | (.rule//.sourceFile) | "\($type) \(.name) \(.ruleClass//"") \(if .ruleInput == null then "" else .ruleInput end)"' \
		| grep SOURCE_FILE | grep -v ' @' \
		| while read -r type name rest; do
			echo "${type} ${name} $(echo "${name}" | perl -pe 's{^//}{}; s{:}{/}')"
		done

# Compare files in bazel and git
[no-cd]
ls-files dir rule:
	@diff <(git ls-files {{dir}} | sort) <(j bazel::source {{rule}} | awk '{print $NF}' | sort) | egrep '^[<>]' | sort | grep -v -E '(WORKSPACE|MODULE.bazel|BUILD.bazel)$'
