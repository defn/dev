package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu/m\">TOC</a>"
	steps: [{
		title: "Update $HOME, then install everything"
		desc: "git pull; make install"
	}, {
		title: "Setup GPG"
		desc: "make gpg"
	}, {
		title: "Auto-bump flakes"
		desc: "make update"
	}, {
		title: "Run CI"
		desc: "make ci"
	}, {
		title: "Run Za Warudo"
		desc: "cd m; make za"
	}, {
		title: "Run Teacher's Coder"
		desc: "make dev"
	}]
}
