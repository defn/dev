# Helix Organization Infrastructure

Organization-level Terraform configuration for the helix AWS organization.

## Usage

```bash
cd infra/org-helix
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-helix/terraform.tfstate`)
- **Profile**: `helix-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
