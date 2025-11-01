# whoa-org Account Infrastructure

Account-specific Terraform configuration for the whoa organization's org account.

## Usage

```bash
cd infra/acc-whoa-org
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-whoa-org/terraform.tfstate`)
- **Profile**: `whoa-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
