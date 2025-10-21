# CLAUDE.md - CUE Configuration System

This directory implements a layered CUE configuration system that validates and unifies data from multiple sources.

## Purpose

This work area manages configuration validation across four layers:
- **intention/** - CUE schemas that define structure and constraints
- **definition/** - Configuration data from YAML files
- **execution/** - Build artifacts from Kubernetes manifests
- **application/** - Live data from external APIs (GitHub)

## Common Commands

- **Run full ingestion pipeline**: `./ingest.sh`
- **Evaluate unified configuration**: `cue eval`
- **Format CUE files**: `cue fmt **/*.cue`

## Common Tasks

### Task: ingest

When asked to "run ingest task" or "refresh data", follow these steps:

1. Run the ingestion pipeline: `./ingest.sh`
2. This will:
   - Convert `repo.yaml` to CUE format in `definition/`
   - Convert kustomize output to CUE format in `execution/`
   - Fetch GitHub API data to CUE format in `application/`
   - Evaluate and unify all layers with `cue eval`
3. Review any validation errors from CUE unification
4. If changes were made to generated files, stage and commit them

### Task: validate

When asked to "validate configuration" or "check schemas", follow these steps:

1. Run `cue vet ./...` to validate all CUE files
2. Check for unification errors between layers
3. Report any schema violations or type mismatches

### Task: add schema

When asked to add a new schema definition:

1. Create or update schema files in `intention/`
2. Define the structure using CUE's type system
3. Run `./ingest.sh` to re-validate existing data against new schema
4. Update ingestion scripts if new data sources are needed

## Important Notes

- Always run `./ingest.sh` after modifying schemas to ensure all layers still unify
- Generated files (`gen.cue` in each subdirectory) should not be manually edited
- Schema changes in `intention/` may break existing data - validate carefully
- The unification model ensures consistency across all configuration sources

## Architecture Context

This CUE system is part of the larger Bazel monorepo at `/home/ubuntu/m/`. It provides type-safe configuration management for Kubernetes resources and repository metadata, ensuring that configuration files, build outputs, and live API data all conform to defined schemas.
