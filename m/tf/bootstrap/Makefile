config:
	for a in $$(b aws); do cat template/provider.es | env PROFILE="$$a" envsubst; echo; echo; done > provider.tf
	for a in $$(b aws); do mkdir -p account-$$a; cat template/account.es | env ACCOUNT="$$a" envsubst > account-$$a/account.tf; ln -nfs ../{provider.tf,version.tf,terraform.tfvars,.terraform.lock.hcl} account-$$a/; ln -nfs ../../context.tf account-$$a/; done
	for a in $$(b aws); do cat template/backend.es | env ACCOUNT="$$a" CONFIG=bootstrap/account-$$a envsubst > account-$$a/backend.tf; done
	terraform fmt */