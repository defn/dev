update:
	git pull
	hof mod vendor cue
	cat .tool-versions  | awk '{print $$1}' | while read -r a; do asdf list-all $$a | sed "s#^#$$a #"; done | sort > .tool-versions-all

open:
	devcontainer open
