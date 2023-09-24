lesson:
	cue eval --out json -e html | jq -r . > tutorial.html

build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --image=$(image)
	docker pull $(image)
