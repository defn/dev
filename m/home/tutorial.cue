package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	steps: [{
		title: "Run CI"
		desc: "make ci"
	}, {
		title: "Run Za Warudo"
		desc: "make za"
	}, {
		title: "Run Teacher's Coder"
		desc: "make dev"
	}, {
		title: "Update $HOME, then install everything"
		desc: "(cd && git pull && make install)"
	}, {
		title: "Setup GPG"
		desc: "(cd && make gpg)"
	}, {
		title: "Auto-bump flakes"
		desc: "(cd && make update)"
	}]
}
