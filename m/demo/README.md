# Demonstration of defn.dev

This is a Terraform configuration of AWS Organizations with four accounts: org master, ops, net, and dev.

Tools installed with Nix.

Terraform generated with CDKTF Golang.

Configurations managed with CUE.

# Onboarding

Any defn.dev admin must be able to run the following:

```
# get a nix shell
sudo chown ubuntu:ubuntu /workspaces/defn
direnv allow
nix develop

# install language tools
make install

# verify aws access
make whoami

# terraform plan something
cd cfg/remote-state
terraform init
terraform plan

cd ../../stacks/org-demo
terraform init
terraform plan

cd ../acc-demo-org
terraform init
terraform plan
```

# Setup

## AWS Organization Master Account

1. Create AWS account: PREFIX+NAME-org@domain.tld
2. Add MFA https://us-east-1.console.aws.amazon.com/iam/home#/security_credentials
3. Activate IAM Access https://us-east-1.console.aws.amazon.com/billing/home#/account

## AWS IAM Identity Center

1. Pick a region other than your main
2. Choose AWS Organizations
3. Pick access portal name
4. Create PermissionSet AdminstratorAccess
5. Create admin user
6. Create ops Organization account
7. Delegate to ops account
8. Deploy

### Customize AWS Config

1. Edit .envrc, change region
2. Edit cfg/.aws/config, change region, names, IDs, Administrator to AdministratorAccess temporarily
3. Edit cfg/cfg.cue, change region, names, IDs
4. Test access with `make whoami`, only org, ops accounts will work at this point

### Initialize GitOps

1. Get a shell: `direnv allow && nix develop`
2. Install stuff: `make install`
3. `cd cfg && make build`
4. Make remote-state

```
cd cfg/remote-state
rm -f backend.tf
vi remote-state.tf
tf init
tf plan
tf apply
tf init
tf plan
rm terraform.tfstate*
tf locks
```

5. Generate locks: `cd cdktf.out/stacks/org-demo && tf init && tf locks`
6. Import aws organization: `terraform import aws_organizations_organization.organization o-gmfp7o9c7c`
7. Import aws organization master account: `terraform import aws_organizations_account.org 992382597334`
8. Import aws organization ops account: `terraform import aws_organizations_account.ops 339712953662`
9. Depoy the org config: `tf plan; tf apply`
10. Fill out rest of `cfg/.aws/config` and `cfg/cfg.cue`, remove `Access` role suffix
11. Verify aws credentials: `aws-vault clear; make whoami`
12. For each `cdktf.out/stacks/acc-*/`, `tf init && tf locks && tf plan && tf apply`
13. Clean up AdminstratorAccess PermissonSet
