# helix-ops Account Infrastructure

Account-specific Terraform configuration for the helix organization's ops account.

## Usage

```bash
cd infra/acc-helix-ops
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-ops/terraform.tfstate`)
- **Profile**: `helix-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
