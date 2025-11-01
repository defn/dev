# AWS Mise Environments

Auto-generated mise configurations for AWS SSO profiles across 14 organizations.

## Usage

Activate an AWS environment using mise:

```bash
cd a/fogg/ops       # Navigate to organization/account
mise trust          # Trust the mise.toml (first time only)
# Environment activated - AWS_PROFILE and AWS_CONFIG_FILE are set
aws sso login       # Authenticate and get credentials
alogin              # Open AWS web console in browser
aws sts get-caller-identity
```

## Structure

```
a/
└── {org}/              # Organization directories (14 total)
    └── {account}/      # Account directories (e.g., org, ops, ci, dev)
        ├── mise.toml   # Sets AWS_PROFILE and AWS_REGION
        └── .aws/config # SSO profile configuration
```

## Organizations

This directory contains configurations for 14 AWS organizations (~145 accounts total):

**Complete (10-account structure):**

- `fogg/` - 10 accounts (org, ops, ci, dev, hub, lib, log, net, prod, pub)
- `helix/` - 10 accounts
- `spiral/` - 10 accounts
- `vault/` - 10 accounts

**Infrastructure-focused:**

- `circus/` - 5 accounts (org, lib, log, net, ops)
- `coil/` - 4 accounts (org, hub, lib, net)
- `curl/` - 4 accounts (org, hub, lib, net)
- `gyre/` - 2 accounts (org, ops)
- `jianghu/` - 3 accounts (org, log, net)

**Special purpose:**

- `chamber/` - 30 accounts (large multi-environment)
- `defn/` - 1 account (bootstrap IAM)
- `immanent/` - 12 accounts (Earthsea-themed names)
- `imma/` - 6 accounts
- `whoa/` - 4 accounts

See individual organization README.md files for account details.

## Generated Files

All `mise.toml` and `.aws/config` files are auto-generated from CUE definitions. Do not edit manually.

**Source:** `c/definition/aws/aws.cue` → Transform phase → `a/{org}/{account}/`
