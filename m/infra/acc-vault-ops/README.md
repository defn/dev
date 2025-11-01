# vault-ops Account Infrastructure

Account-specific Terraform configuration for the vault organization's ops account.

## Usage

```bash
cd infra/acc-vault-ops
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-ops/terraform.tfstate`)
- **Profile**: `vault-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
