# Chamber Environment: q

AWS environment configuration for chamber-q profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-q
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/q
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
