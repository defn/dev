# whoa-pub Account Infrastructure

Account-specific Terraform configuration for the whoa organization's pub account.

## Usage

```bash
cd infra/acc-whoa-pub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-whoa-pub/terraform.tfstate`)
- **Profile**: `whoa-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
