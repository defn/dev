# vault-prod Account Infrastructure

Account-specific Terraform configuration for the vault organization's prod account.

## Usage

```bash
cd infra/acc-vault-prod
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-prod/terraform.tfstate`)
- **Profile**: `vault-prod`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
