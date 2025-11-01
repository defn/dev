# immanent-hand Account Infrastructure

Account-specific Terraform configuration for the immanent organization's hand account.

## Usage

```bash
cd infra/acc-immanent-hand
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-hand/terraform.tfstate`)
- **Profile**: `immanent-hand`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
