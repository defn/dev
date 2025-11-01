# spiral-lib Account Infrastructure

Account-specific Terraform configuration for the spiral organization's lib account.

## Usage

```bash
cd infra/acc-spiral-lib
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-lib/terraform.tfstate`)
- **Profile**: `spiral-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
