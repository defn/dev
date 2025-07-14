# Docker Cache Configuration

This directory contains Docker registry and caching configuration for development environments.

## Files

- `Makefile` - Docker cache management tasks
- `config.yml` - Docker registry configuration
- `docker-compose.yaml` - Docker services orchestration
- `k3d.yaml` - K3d cluster configuration
- `nginx.yaml` - Nginx configuration for registry
- `registries.yaml` - Registry configuration for K3d

## Subdirectories

- `certs/` - SSL certificates for Docker registry

## Purpose

Provides a local Docker registry and caching infrastructure to improve build performance and reduce external dependencies during development.

## Usage

Use the Makefile to manage the Docker cache services, and docker-compose to orchestrate the registry and related services.