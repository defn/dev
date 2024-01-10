lesson:
	cue eval --out json -e html | jq -r . > tutorial.html
	for h in hook; do cue export -p l --out json -e hooks.$$h.config > hooks/$$h.json; done

build-operator:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --image=$(image)
	docker pull $(image)
