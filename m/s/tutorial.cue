package l

page: content: html: tutorial.html

tutorial: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	iframe: "https://3030--main--pc--admin.local.defn.run"
	steps: [{
		title: "Run the slide-show with Tilt"
		desc:  "tilt up --stream --port 0"
	}, {
		title: "Load the slide-show"
		desc:  "Once the slide-show is running, cick on retry below to load the slide-show"
	}, {
		title: "Edit slides.md file, change \"Welcome to Slidev\"."
		desc:  "Watch slide-show update."
	}]
}
