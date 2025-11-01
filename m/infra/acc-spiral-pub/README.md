# spiral-pub Account Infrastructure

Account-specific Terraform configuration for the spiral organization's pub account.

## Usage

```bash
cd infra/acc-spiral-pub
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-pub/terraform.tfstate`)
- **Profile**: `spiral-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
