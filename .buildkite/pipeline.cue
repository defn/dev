package bk

import (
	"github.com/defn/dev/m/c/infra"
)

#scripts: "./.buildkite/bin"

// bazel query "kind('source file', deps(//cmd))" --output=label_kind | perl -ne '(s{source file //}{} && s{:}{/} && s{/?[^/\s]+$}{} && print) if m{^source file\s+//([^@]*\.go)$}' | sort -u
#cmd: [
	"cmd",
	"command/api",
	"command/gollm",
	"command/meh",
	"command/tui",
	"command/root",
	"command/tui",
]

steps: [{
	label:   "home build"
	command: "\(#scripts)/home-build.sh"
}, {
	label:   "trunk check"
	command: "\(#scripts)/trunk-check.sh"
}, {
	label:   "bazel build"
	command: "\(#scripts)/bazel-build.sh"
}, {
	label: "Website deploys"
	// https://github.com/buildkite-plugins/monorepo-diff-buildkite-plugin/releases
	plugins: [{
		"monorepo-diff#v1.5.1": {
			watch: [
				for d in infra.domains {
					path: "m/w/sites/\(d)/"
					config: command: "\(#scripts)/deploy-cf-pages.sh m/w/sites/\(d)"
				},
			]
		}
	}]
}, {
	label:   "cmd deploys"
	command: "\(#scripts)/build-cmd.sh"
	plugins: [{
		"monorepo-diff#v1.5.1": {
			watch: [
				for d in #cmd {
					"m/\(d)/"
				},
			]
		}
	}]
}]
