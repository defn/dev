# spiral-ci Account Infrastructure

Account-specific Terraform configuration for the spiral organization's ci account.

## Usage

```bash
cd infra/acc-spiral-ci
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-ci/terraform.tfstate`)
- **Profile**: `spiral-ci`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
