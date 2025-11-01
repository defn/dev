# imma-pub Account Infrastructure

Account-specific Terraform configuration for the imma organization's pub account.

## Usage

```bash
cd infra/acc-imma-pub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-pub/terraform.tfstate`)
- **Profile**: `imma-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
