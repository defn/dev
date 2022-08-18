SHELL := /bin/bash

podname ?= $(shell basename $(shell pwd))-0
context ?= k3d-$(shell basename $(shell pwd))
domain ?= tiger-mamba.ts.net

# export DIGITALOCEAN_ACCESS_TOKEN="$(pass DIGITALOCEAN_ACCESS_TOKEN)"
# export TF_TOKEN_app_terraform_io="$(pass TF_TOKEN_app_terraform_io)"

# doctl kubernetes cluster kubeconfig save remo

shell:
	env \
		DIGITALOCEAN_ACCESS_TOKEN="$$(pass DIGITALOCEAN_ACCESS_TOKEN)" \
		TF_TOKEN_app_terraform_io="$$(pass TF_TOKEN_app_terraform_io)" \
		FLY_API_TOKEN="$$(pass FLY_API_TOKEN)" \
		$(SHELL)

test:
	$(MAKE) fmt
	$(MAKE) validate

clean:
	rm -f main.tf.json

init:
	terraform init -upgrade
	terraform providers lock \
		-platform=linux_arm64 \
		-platform=linux_amd64 \
		-platform=darwin_amd64 \
		-platform=darwin_arm64

upgrade:
	terraform init -upgrade

fmt:
	for a in *.tf *.tfvars; do if [[ -f $$a ]]; then terraform fmt $$a; fi; done

validate:
	terraform validate

plan:
	env TF_VAR_home=$(HOME) terraform plan -out=.plan

planned:
	terraform show .plan

apply:
	terraform apply .plan
	rm -f .plan

refresh:
	terraform refresh

console:
	terraform console

one:
	$(MAKE) plan-one apply

zero:
	$(MAKE) plan-zero apply

plan-one:
	env TF_VAR_want=1 $(MAKE) plan

plan-zero:
	env TF_VAR_want=0 $(MAKE) plan

kubeconfig:
	doctl kubernetes cluster kubeconfig save remo

attach:
	code --folder-uri vscode-remote://k8s-container+context=$(context)+namespace=default+podname=$(podname)+name=dev+/home/ubuntu

archive:
	pass hello
	rm -rf tmp
	mkdir tmp
	mkdir -p tmp/$(name)/var/lib/tailscale
	mkdir -p tmp/$(name)/var/lib/rancher/k3s/server/tls
	pass k3d-$(name)-client-ca.crt | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.crt
	pass k3d-$(name)-client-ca.key | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.key
	pass k3d-$(name)-server-ca.crt | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/server-ca.crt
	pass k3d-$(name)-server-ca.key | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/server-ca.key
	pass tailscale_k3d-$(name) | base64 -d > tmp/$(name)/var/lib/tailscale/tailscaled.state
	echo "archive_$(name) = \"$$(cd tmp/$(name) && tar cvf - . | base64 -w 0)\"" >> terraform.tfvars
	echo >> terraform.tfvars
	step certificate create system:admin tmp/$(name)/var/lib/rancher/k3s/server/tls/client.crt tmp/$(name)/var/lib/rancher/k3s/server/tls/client.key --no-password --ca tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.crt --ca-key tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.key  --insecure --force --template client.tpl
	k config set-cluster k3d-$(name) --embed-certs --certificate-authority tmp/$(name)/var/lib/rancher/k3s/server/tls/server-ca.crt --server https://k3d-$(name).$(domain):6443
	k config set-credentials k3d-$(name) --embed-certs --client-certificate tmp/$(name)/var/lib/rancher/k3s/server/tls/client.crt --client-key tmp/$(name)/var/lib/rancher/k3s/server/tls/client.key
	k config set-context k3d-$(name) --cluster k3d-$(name) --user k3d-$(name)
	rm -rf tmp
	argocd cluster add k3d-$(name) --yes --upsert
	k --context argocd apply -f ../../e/k3d-$(name).yaml
