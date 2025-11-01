# helix-pub Account Infrastructure

Account-specific Terraform configuration for the helix organization's pub account.

## Usage

```bash
cd infra/acc-helix-pub
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-pub/terraform.tfstate`)
- **Profile**: `helix-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
