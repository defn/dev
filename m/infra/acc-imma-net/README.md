# imma-net Account Infrastructure

Account-specific Terraform configuration for the imma organization's net account.

## Usage

```bash
cd infra/acc-imma-net
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-net/terraform.tfstate`)
- **Profile**: `imma-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
