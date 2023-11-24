package l

page: content: html: """
	\(tutorial.html)
	"""

tutorial: #TutorialContent & {
	title: "Table of Contents"
	steps: [{
		title: "<a href=\"/?folder=/home/ubuntu\">/home/ubuntu</a>"
		desc:  "$HOME directory"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m\">m</a>"
		desc:  "Monorepo root"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/s/dev\">m/s/dev</a>"
		desc:  "Slide-show using sli.dev"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/h/example\">m/h/example</a>"
		desc:  "Shell-operator example"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/pkg\">m/pkg</a>"
		desc:  "nix flakes"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/c\">m/c</a>"
		desc:  "Kubernetes configuration"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/coder/aws\">m/coder/aws</a>"
		desc:  "Coder AWS AMI image"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/coder/pod\">m/coder/pod</a>"
		desc:  "Coder Docker image"
	}]
}
