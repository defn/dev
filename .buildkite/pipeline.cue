package bk

import (
	"github.com/defn/dev/m/c/infra"
)

#scripts: "./.buildkite/bin"

steps: [{
	label:   "trunk check"
	command: "\(#scripts)/trunk-check.sh"
}, {
	label:   "bazel build"
	command: "\(#scripts)/bazel-build.sh"
}, {
	label:   "home build"
	command: "\(#scripts)/home-build.sh"
}, {
	label: "Website deploys"
	plugins: [{
		"monorepo-diff#v1.2.0": {
			watch: [
				for d in infra.domains {
					path: "m/w/sites/\(d)/"
					config: command: "\(#scripts)/deploy-cf-pages.sh m/w/sites/\(d)"
				},
			]
		}
	}]
}]
