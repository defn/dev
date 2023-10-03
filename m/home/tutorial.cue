package l

page: content: #TutorialContent & {
	title: "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	steps: [{
		title: "Run CI"
		desc:  "make ci"
	}, {
		title: "Run Za Warudo"
		desc:  "make za"
	}, {
		title: "Run Teacher Coder"
		desc:  "make dev"
	}, {
		title: "Initialize Class Coder"
		desc:  "make class-init"
	}, {
		title: "Push Class Template"
		desc:  "(cd coder/class && make push)"
	}, {
		title: "Update $HOME, then install everything"
		desc:  "(cd && git pull && make install)"
	}, {
		title: "Setup GPG"
		desc:  "(cd && make gpg)"
	}, {
		title: "Auto-bump flakes"
		desc:  "(cd && make update)"
	}]
}
