# Chamber Environment: 5

AWS environment configuration for chamber-5 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-5
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/5
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
