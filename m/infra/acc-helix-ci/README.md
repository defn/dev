# helix-ci Account Infrastructure

Account-specific Terraform configuration for the helix organization's ci account.

## Usage

```bash
cd infra/acc-helix-ci
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-ci/terraform.tfstate`)
- **Profile**: `helix-ci`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
