# Vault Organization Infrastructure

Organization-level Terraform configuration for the vault AWS organization.

## Usage

```bash
cd infra/org-vault
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-vault/terraform.tfstate`)
- **Profile**: `vault-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
