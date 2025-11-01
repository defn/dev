# helix-log Account Infrastructure

Account-specific Terraform configuration for the helix organization's log account.

## Usage

```bash
cd infra/acc-helix-log
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-log/terraform.tfstate`)
- **Profile**: `helix-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
