package l

page: content: html: """
	\(tutorial.html)
	<br>
	<iframe height="500px" src="https://3030--main--dev--amanibhavam.coder.dev.amanibhavam.defn.run"/>
	"""

tutorial: #TutorialContent & {
	title: "Tutorial"
	steps: [{
		title: "Run the slide-show with Tilt"
		desc:  "tilt up"
	}, {
		title: "One the slide-show is running, cick on retry below to load the slide-show",
		desc:  ""
	}, {
		title: "Edit slides.md file, change \"Welcome to Slidev\".  Then watch slide-show update."
		desc:  ""
	}]
}
