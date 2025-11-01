# Helix AWS Organization

AWS SSO configuration for the helix organization.

## Usage

Activate an account environment:

```bash
cd a/helix/ops
mise trust
aws sts get-caller-identity
```

## Accounts

This organization contains 10 AWS account(s):

- `ci/` - helix-ci profile
- `dev/` - helix-dev profile
- `hub/` - helix-hub profile
- `lib/` - helix-lib profile
- `log/` - helix-log profile
- `net/` - helix-net profile
- `ops/` - helix-ops profile
- `org/` - helix-org profile
- `prod/` - helix-prod profile
- `pub/` - helix-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
