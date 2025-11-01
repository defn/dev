# fogg-ops Account Infrastructure

Account-specific Terraform configuration for the fogg organization's ops account.

## Usage

```bash
cd infra/acc-fogg-ops
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-ops/terraform.tfstate`)
- **Profile**: `fogg-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
