package l

page: content: html: """
	\(tutorial.html)
	<br>
	<iframe height="500px" src="https://whimsical.com/tri-deca-hexa-gong-6gVrJoZV7XQ9HhXpCzxrzp"/>
	"""

tutorial: #TutorialContent & {
	title: "Table of Contents"
	steps: [{
		title: "<a href=\"/?folder=/home/ubuntu\">/home/ubuntu</a>"
		desc: "$HOME directory"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/l/dev\">m/l/dev</a>"
		desc: "Slide-show using sli.dev"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/h/example\">m/h/example</a>"
		desc: "Shell-operator example"
	}, {
		title: "<a href=\"/?folder=/home/ubuntu/m/pkg\">m/pkg</a>"
		desc: "nix flakes"
	}]
}
