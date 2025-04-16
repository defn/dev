package bk

import (
	"github.com/defn/dev/m/c/infra"
)

#scripts: "./.buildkite/bin"

// bazel query "kind('source file', deps(//cmd))" --output=label_kind | perl -ne '(s{source file //}{} && s{:}{/} && s{/?[^/\s]+$}{} && print) if m{^source file\s+//([^@]*\.go)$}' | sort -u
#cmd: [
	"cmd",
	"command/api",
	"command/infra",
	"command/root",
	"command/tui",
	"infra",
	"tf",
	"tf/gen/terraform_aws_defn_account",
	"tf/gen/terraform_aws_defn_account/internal",
	"tf/gen/terraform_aws_defn_account/jsii",
	"tf/gen/terraform_aws_s3_bucket",
	"tf/gen/terraform_aws_s3_bucket/internal",
	"tf/gen/terraform_aws_s3_bucket/jsii",
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
}, {
	label:   "cmd deploys"
	command: "\(#scripts)/build-cmd.sh"
	plugins: [{
		"monorepo-diff#v1.2.0": {
			watch: [
				for d in #cmd {
					"m/\(d)/"
				},
			]
		}
	}]
}]
