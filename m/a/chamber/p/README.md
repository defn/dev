# Chamber Environment: p

AWS environment configuration for chamber-p profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-p
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/p
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
