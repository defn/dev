# Chamber Environment: o

AWS environment configuration for chamber-o profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-o
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/o
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
