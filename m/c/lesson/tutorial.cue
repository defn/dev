package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu/m\">TOC</a>"
	steps: [{
		title: "Update the list of Docker images and helm chart versions"
		desc:  "make list"
	}, {
		title: "Cache images in images.txt to local registry"
		desc:  "make cache"
	}, {
		title: "Update the Helm chart versions in file kustomize.cue, then regenerate YAML."
		desc:  "(cd dfd && make)"
	}, {
		title: "View the YAML diff"
		desc:  "git diff --cached ../k/r"
	}]
}
