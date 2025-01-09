init:
	mkdir -p certs images
	cd certs && step certificate create --subtle --insecure --no-password --force --profile self-signed --san 169.254.32.1 k3d-registry registry.crt registry.key
	sudo cp certs/registry.crt /etc/ssl/certs/k3d-registry.crt
	sudo update-ca-certificates

up:
	docker compose down || true
	docker compose up -d --remove-orphans
