SHELL := /bin/bash

# export DIGITALOCEAN_ACCESS_TOKEN="$(pass DIGITALOCEAN_ACCESS_TOKEN)
# export TF_TOKEN_app_terraform_io="$(pass TF_TOKEN_app_terraform_io)"

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
	terraform plan -out=.plan

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
	$(MAKE) plan apply

zero:
	$(MAKE) plan-zero apply-zero

plan-zero:
	env TF_VAR_want=0 $(MAKE) plan
