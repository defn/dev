# circus-ops Account Infrastructure

Account-specific Terraform configuration for the circus organization's ops account.

## Usage

```bash
cd infra/acc-circus-ops
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-circus-ops/terraform.tfstate`)
- **Profile**: `circus-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
