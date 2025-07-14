# Chamber Environment: 4

AWS environment configuration for chamber-4 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-4
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/4
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
