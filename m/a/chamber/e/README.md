# Chamber Environment: e

AWS environment configuration for chamber-e profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-e
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/e
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
