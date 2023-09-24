lesson:
	cue eval --out json -e html | jq -r . > tutorial.html
	cue export -p l --out json -e config > config.json

build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --image=$(image)
	docker pull $(image)
