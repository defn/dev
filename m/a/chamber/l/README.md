# Chamber Environment: l

AWS environment configuration for chamber-l profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-l
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/l
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
