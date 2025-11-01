# vault-log Account Infrastructure

Account-specific Terraform configuration for the vault organization's log account.

## Usage

```bash
cd infra/acc-vault-log
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-log/terraform.tfstate`)
- **Profile**: `vault-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
