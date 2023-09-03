build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build --image=$(image)
	docker pull $(image)

log:
	stern hook-