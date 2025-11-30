package bk

#scripts: "./.buildkite/bin"

steps: [{
	label:   "home build"
	command: "\(#scripts)/home-build.sh"
}, {
	label:   "trunk check"
	command: "\(#scripts)/trunk-check.sh"
}, {
	label:   "bazel build"
	command: "\(#scripts)/bazel-build.sh"
}]
