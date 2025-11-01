# Vault AWS Organization

AWS SSO configuration for the vault organization.

## Usage

Activate an account environment:

```bash
cd a/vault/ops
mise trust
aws sso login
aws sts get-caller-identity
```

## Accounts

This organization contains 10 AWS account(s):

- `ci/` - vault-ci profile
- `dev/` - vault-dev profile
- `hub/` - vault-hub profile
- `lib/` - vault-lib profile
- `log/` - vault-log profile
- `net/` - vault-net profile
- `ops/` - vault-ops profile
- `org/` - vault-org profile
- `prod/` - vault-prod profile
- `pub/` - vault-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
