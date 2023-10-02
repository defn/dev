package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	steps: [{
		title: "Update the list of Helm chart versions"
		desc:  "make list"
	}, {
		title: "Update the Helm chart versions in file kustomize.cue, then regenerate YAML."
		desc:  "(cd dfd && make)"
	}, {
		title: "View the YAML diff"
		desc:  "git diff --cached ../k/y"
	}]
}
