# chamber-7 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 7 account.

## Usage

```bash
cd infra/acc-chamber-7
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-7/terraform.tfstate`)
- **Profile**: `chamber-7`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
