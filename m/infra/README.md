# Infrastructure as Code

Terraform configurations for AWS infrastructure across 14 organizations and ~145 accounts.

## Structure

```
infra/
├── global/           # Global/cross-account infrastructure
├── output/           # Centralized remote state aggregation
├── org-{name}/       # Organization-level resources (14 orgs)
├── acc-{org}-{acct}/ # Account-level resources (~145 accounts)
└── mise.toml         # Environment configuration
```

## Directory Types

### global/

Cross-account and global infrastructure resources.

### output/

Centralized Terraform configuration that aggregates remote state outputs from all infrastructure stacks. Uses `terraform_remote_state` data sources to query outputs from:
- `global/` stack
- All 14 `org-{name}/` stacks
- All ~145 `acc-{org}-{account}/` stacks

Provides a single aggregated output `all` containing outputs from every managed stack for centralized state querying.

### org-{name}/

Organization-level Terraform configurations for AWS Organizations, SSO, and cross-account resources:

- `org-chamber/` - Chamber organization (35 accounts)
- `org-circus/` - Circus organization (5 accounts)
- `org-coil/` - Coil organization (4 accounts)
- `org-curl/` - Curl organization (4 accounts)
- `org-defn/` - Defn organization (1 account)
- `org-fogg/` - Fogg organization (10 accounts)
- `org-gyre/` - Gyre organization (2 accounts)
- `org-helix/` - Helix organization (10 accounts)
- `org-imma/` - Imma organization (6 accounts)
- `org-immanent/` - Immanent organization (12 accounts)
- `org-jianghu/` - Jianghu organization (3 accounts)
- `org-spiral/` - Spiral organization (10 accounts)
- `org-vault/` - Vault organization (10 accounts)
- `org-whoa/` - Whoa organization (5 accounts)

### acc-{org}-{account}/

Account-specific Terraform configurations for individual AWS accounts. Each directory contains:

- `cdk.tf` - Terraform configuration with provider and backend
- `mise.toml` - Environment configuration for AWS profile
- `mod/` - Terraform modules (symlink)

## Usage

Each directory contains a `mise.toml` that sets up the appropriate AWS profile:

```bash
cd infra/acc-fogg-ops
mise trust
aws sso login       # Authenticate and get credentials
alogin              # Open AWS web console in browser
terraform init
terraform plan
```

## Backend Configuration

All Terraform state is stored in S3 with **file-based locking**:

```hcl
backend "s3" {
  bucket       = "dfn-defn-terraform-state"
  use_lockfile = true
  encrypt      = true
  key          = "stacks/{directory}/terraform.tfstate"
  profile      = "defn-org"
  region       = "us-east-1"
}
```

State files are organized by path:

- `stacks/global/terraform.tfstate`
- `stacks/output/terraform.tfstate`
- `stacks/org-{name}/terraform.tfstate`
- `stacks/acc-{org}-{account}/terraform.tfstate`

## Terraform Provider

All configurations use AWS provider version `5.99.1`.

## Development Workflow

1. Navigate to the appropriate directory
2. Trust mise configuration: `mise trust`
3. Authenticate with AWS SSO: `aws sso login`
4. Open AWS web console (optional): `alogin`
5. Initialize Terraform: `terraform init`
6. Review changes: `terraform plan`
7. Apply changes: `terraform apply`

See individual directory READMEs for specific configuration details.
