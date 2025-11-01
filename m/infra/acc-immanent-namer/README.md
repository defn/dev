# immanent-namer Account Infrastructure

Account-specific Terraform configuration for the immanent organization's namer account.

## Usage

```bash
cd infra/acc-immanent-namer
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-namer/terraform.tfstate`)
- **Profile**: `immanent-namer`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
