# chamber-p Account Infrastructure

Account-specific Terraform configuration for the chamber organization's p account.

## Usage

```bash
cd infra/acc-chamber-p
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-p/terraform.tfstate`)
- **Profile**: `chamber-p`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
