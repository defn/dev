# chamber-d Account Infrastructure

Account-specific Terraform configuration for the chamber organization's d account.

## Usage

```bash
cd infra/acc-chamber-d
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-d/terraform.tfstate`)
- **Profile**: `chamber-d`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
