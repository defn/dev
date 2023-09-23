package l

page: content: html: """
	<iframe src="https://10350--main--dev--amanibhavam.coder.dev.amanibhavam.defn.run" frameborder="0"></iframe>
	"""

oldpage: content: #TutorialContent & {
	title: "Tutorial"
	steps: [{
		title: "Change to workshop <a href=\"/?folder=/home/ubuntu/m/l/dev/lesson\">directory</a>"
		desc:  "cd workshop"
	}, {
		title: "Install npm packages"
		desc:  "npm install"
	}, {
		title: "Run the slide-show.  This command will launch a browser to the slide-show."
		desc:  "npm run dev -- --remote"
	}, {
		title: "Edit slides.md file, change \"Welcome to Slidev\".  Then watch slide-show update."
		desc:  ""
	}]
}
