# Chamber Environment: b

AWS environment configuration for chamber-b profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-b
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/b
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
