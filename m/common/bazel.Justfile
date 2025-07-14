# Runs Bazel build
# Description: Executes Bazel build command using the 'b' wrapper
# Dependencies: bazel (b wrapper)
# Outputs: Built targets according to Bazel configuration
[no-cd]
build:
	@b build

# Runs iBazel watch
# Description: Starts iBazel to watch and rebuild on file changes
# Dependencies: bazel (b wrapper), ibazel
# Outputs: Continuous build output on file changes
[no-cd]
watch:
	@b watch

# json build graph
# Description: Generates JSON representation of Bazel dependency graph for a rule
# Dependencies: bazel, jq
# Outputs: JSON array of dependencies for the specified rule
[no-cd]
json rule:
	@bazel query --noimplicit_deps 'deps({{rule}})' --output streamed_jsonproto | jq -s .

# List source nodes
# Description: Extracts and lists source files from Bazel dependency graph
# Dependencies: bazel, just, gron, jq, grep, perl
# Outputs: List of source files with type and path information
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
# Description: Shows differences between files tracked by git and Bazel for a directory
# Dependencies: git, just (j), diff, awk, egrep, grep
# Outputs: Files present in only git (<) or only Bazel (>), excluding Bazel config files
[no-cd]
ls-files dir rule:
	@diff <(git ls-files {{dir}} | sort) <(j bazel::source {{rule}} | awk '{print $NF}' | sort) | egrep '^[<>]' | sort | grep -v -E '(WORKSPACE|MODULE.bazel|BUILD.bazel)$'
