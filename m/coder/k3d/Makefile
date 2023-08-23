build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build
	docker pull quay.io/defn/dev:latest-k3d
	k3d cluster delete dfd
	while true; do docker logs -f k3d-dfd-server-0; sleep 1; done