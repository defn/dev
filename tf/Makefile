SHELL := /bin/bash

workdir ?= /home/ubuntu
podname ?= $(shell basename $(shell pwd))-0
context ?= k3d-$(shell basename $(shell pwd))

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
	code --folder-uri vscode-remote://k8s-container+context=$(context)+namespace=default+podname=$(podname)+name=dev+$(workdir)

archive:
	rm -rf tmp
	mkdir tmp
	mkdir -p tmp/$(name)/home/ubuntu/d/k3d
	mkdir -p tmp/$(name)/var/lib/rancher/k3s/server/tls
	pass k3d-$(name)-client-ca.crt | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.crt
	pass k3d-$(name)-client-ca.key | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/client-ca.key
	pass k3d-$(name)-server-ca.crt | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/server-ca.crt
	pass k3d-$(name)-server-ca.key | base64 -d > tmp/$(name)/var/lib/rancher/k3s/server/tls/server-ca.key
	pass tailscale_k3d-$(name) | base64 -d > tmp/$(name)/home/ubuntu/d/k3d/tailscaled.state
	echo -n "archive = \"$$(cd tmp/$(name) && tar cvfz - . | base64 -w 0)\"" > terraform.tfvars
	rm -rf tmp
