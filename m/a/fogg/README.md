# Fogg AWS Organization

AWS SSO configuration for the fogg organization.

## Usage

Activate an account environment:

```bash
cd a/fogg/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 10 AWS account(s):

- `org/` - fogg-org profile
- `ci/` - fogg-ci profile
- `dev/` - fogg-dev profile
- `hub/` - fogg-hub profile
- `lib/` - fogg-lib profile
- `log/` - fogg-log profile
- `net/` - fogg-net profile
- `ops/` - fogg-ops profile
- `prod/` - fogg-prod profile
- `pub/` - fogg-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
