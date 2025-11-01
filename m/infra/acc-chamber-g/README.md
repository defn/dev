# chamber-g Account Infrastructure

Account-specific Terraform configuration for the chamber organization's g account.

## Usage

```bash
cd infra/acc-chamber-g
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-g/terraform.tfstate`)
- **Profile**: `chamber-g`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
