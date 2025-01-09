init:
	mkdir -p certs images
	cd certs && step certificate create --subtle --insecure --no-password --force --profile self-signed --san 169.254.32.1 k3d-registry registry.crt registry.key
	sudo cp certs/registry.crt /etc/ssl/certs/registry.crt
	sudo update-ca-certificates

k3d:
	$(MAKE) up
	docker pull nginx		
	docker tag nginx:latest 169.254.32.1:5000/nginx:latest
	docker push 169.254.32.1:5000/nginx:latest
	k3d cluster delete || true
	k3d cluster create \
		--volume "$(PWD)/registries.yaml:/etc/rancher/k3s/registries.yaml" \
		--volume "$(PWD)/certs/registry.crt:/etc/ssl/certs/registry.crt"
	kubectl apply -f nginx.yaml
	kubectl get events -w

up:
	docker compose down || true
	docker compose up -d --remove-orphans
