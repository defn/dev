# chamber-r Account Infrastructure

Account-specific Terraform configuration for the chamber organization's r account.

## Usage

```bash
cd infra/acc-chamber-r
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-r/terraform.tfstate`)
- **Profile**: `chamber-r`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
