SHELL := /bin/bash

# export DIGITALOCEAN_ACCESS_TOKEN="$(pass DIGITALOCEAN_ACCESS_TOKEN)"
# export TF_TOKEN_app_terraform_io="$(pass TF_TOKEN_app_terraform_io)"

# doctl kubernetes cluster kubeconfig save remo

shell:
	env \
		DIGITALOCEAN_ACCESS_TOKEN="$$(pass DIGITALOCEAN_ACCESS_TOKEN)" \
		TF_TOKEN_app_terraform_io="$$(pass TF_TOKEN_app_terraform_io)" \
		$(SHELL)

test:
	$(MAKE) fmt
	$(MAKE) validate

clean:
	rm -f main.tf.json

init:
	terraform init -upgrade

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
	doctl kubernetes cluster kubeconfig save remo

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
