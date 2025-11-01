# vault-hub Account Infrastructure

Account-specific Terraform configuration for the vault organization's hub account.

## Usage

```bash
cd infra/acc-vault-hub
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-hub/terraform.tfstate`)
- **Profile**: `vault-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
