# chamber-m Account Infrastructure

Account-specific Terraform configuration for the chamber organization's m account.

## Usage

```bash
cd infra/acc-chamber-m
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-m/terraform.tfstate`)
- **Profile**: `chamber-m`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
