init:
	mkdir -p certs images
	cd certs && step certificate create --subtle --insecure --no-password --force --profile self-signed --san 169.254.32.1 k3d-registry registry.crt registry.key
	sudo cp certs/registry.crt /etc/ssl/certs/registry.crt
	sudo update-ca-certificates

k3d:
	k3d cluster delete || true
	k3d cluster create \
		--volume "$(PWD)/registries.yaml:/etc/rancher/k3s/registries.yaml" \
		--volume "$(PWD)/certs/registry.crt:/etc/ssl/certs/registry.crt"

up:
	docker compose down || true
	docker compose up -d --remove-orphans
