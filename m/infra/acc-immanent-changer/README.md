# immanent-changer Account Infrastructure

Account-specific Terraform configuration for the immanent organization's changer account.

## Usage

```bash
cd infra/acc-immanent-changer
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-changer/terraform.tfstate`)
- **Profile**: `immanent-changer`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
