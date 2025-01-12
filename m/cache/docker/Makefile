init:
	sudo cp certs/registry.crt /etc/ssl/certs/registry.crt
	sudo update-ca-certificates
	sudo systemctl restart docker

certz:
	mkdir -p certs
	cd certs && step certificate create --not-after=8760h --subtle --insecure --no-password --force --profile self-signed --san 169.254.32.1 k3d-registry registry.crt registry.key

registry:
	docker compose down || true
	docker compose up -d --remove-orphans
	docker pull nginx		
	docker tag nginx:latest 169.254.32.1:5000/nginx:latest
	docker push 169.254.32.1:5000/nginx:latest

k3d:
	k3d cluster create \
		--volume "$(PWD)/registries.yaml:/etc/rancher/k3s/registries.yaml" \
		--volume "$(PWD)/certs/registry.crt:/etc/ssl/certs/registry.crt"
	kubectl create ns demo || true
	kubectl apply -f nginx.yaml
