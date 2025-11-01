# spiral-ops Account Infrastructure

Account-specific Terraform configuration for the spiral organization's ops account.

## Usage

```bash
cd infra/acc-spiral-ops
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-ops/terraform.tfstate`)
- **Profile**: `spiral-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
