# Chamber Environment: a

AWS environment configuration for chamber-a profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-a
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/a
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
