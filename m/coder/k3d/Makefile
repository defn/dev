build:
	env -u SSH_AUTH_SOCK earthly --push --no-output --no-cache +build
	docker pull quay.io/defn/dev:latest-k3d