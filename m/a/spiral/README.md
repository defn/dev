# Spiral AWS Organization

AWS SSO configuration for the spiral organization.

## Usage

Activate an account environment:

```bash
cd a/spiral/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 10 AWS account(s):

- `org/` - spiral-org profile
- `ci/` - spiral-ci profile
- `dev/` - spiral-dev profile
- `hub/` - spiral-hub profile
- `lib/` - spiral-lib profile
- `log/` - spiral-log profile
- `net/` - spiral-net profile
- `ops/` - spiral-ops profile
- `prod/` - spiral-prod profile
- `pub/` - spiral-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
