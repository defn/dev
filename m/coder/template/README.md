# Coder Workspace Templates

This directory contains Coder workspace templates for different development environments and infrastructure providers.

## Files

- `Justfile` - Task runner configuration
- `TODO` - Task list and development notes
- `mise.toml` - Development tool configuration

## Subdirectories

- `coder-defn-docker-template/` - Docker-based workspace template
- `coder-defn-ec2-template/` - AWS EC2-based workspace template
- `coder-defn-k8s-template/` - Kubernetes-based workspace template
- `coder-defn-ssh-template/` - SSH-based workspace template

Each template directory contains:

- `cdk.tf` - Terraform configuration for the workspace
- `mod` - Module definitions
