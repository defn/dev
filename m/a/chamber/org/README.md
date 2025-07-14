# Chamber Environment: org

AWS environment configuration for chamber-org profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-org
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/org
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
