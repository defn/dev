# imma-log Account Infrastructure

Account-specific Terraform configuration for the imma organization's log account.

## Usage

```bash
cd infra/acc-imma-log
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-log/terraform.tfstate`)
- **Profile**: `imma-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
