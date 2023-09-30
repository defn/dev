package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu/m\">TOC</a>"
	steps: [{
		title: "Run CI"
		desc: "make ci"
	}, {
		title: "Run Za Warudo"
		desc: "make za"
	}, {
		title: "Update $HOME, then install everything"
		desc: "(cd && git pull && make install)"
	}, {
		title: "Setup GPG"
		desc: "(cd && make gpg)"
	}, {
		title: "Auto-bump flakes"
		desc: "(cd && make update)"
	}, {
		title: "Run Teacher's Coder"
		desc: "(cd && make dev)"
	}]
}
