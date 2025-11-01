# vault-net Account Infrastructure

Account-specific Terraform configuration for the vault organization's net account.

## Usage

```bash
cd infra/acc-vault-net
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-net/terraform.tfstate`)
- **Profile**: `vault-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
