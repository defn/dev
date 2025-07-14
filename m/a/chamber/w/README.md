# Chamber Environment: w

AWS environment configuration for chamber-w profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-w
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/w
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
