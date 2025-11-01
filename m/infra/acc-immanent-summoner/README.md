# immanent-summoner Account Infrastructure

Account-specific Terraform configuration for the immanent organization's summoner account.

## Usage

```bash
cd infra/acc-immanent-summoner
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-summoner/terraform.tfstate`)
- **Profile**: `immanent-summoner`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
