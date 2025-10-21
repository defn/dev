# CLAUDE.md - CUE Configuration System

This directory implements a layered CUE configuration system that validates and unifies data from multiple sources.

## Purpose

This work area manages configuration validation across four layers:

- **intention/** - CUE schemas that define structure and constraints
- **definition/** - Configuration data from YAML files
- **execution/** - Build artifacts from Kubernetes manifests
- **application/** - Live data from external APIs (GitHub)

## Inventory Schemas Pattern

This system uses **Inventory Schemas** to create type-safe inventories of configuration items. The pattern has three components:

### 1. Schema Definition

Define typed schemas with `#` prefix to specify structure and constraints:

```cue
#GitRepo: {
    name:        string
    description: string | *""
    createdAt?:  string
    updatedAt?:  string
    url?:        string
}
```

### 2. Inventory Field with Schema Constraint

Apply the schema to an indexed field, binding the key to a constraint:

```cue
repo: [NAME=string]: #GitRepo & {
    name: NAME
}
```

This creates an inventory where:

- Each entry is indexed by a key (e.g., `repo.dev`, `repo.guide`)
- The key must match a field in the schema (`name: NAME`)
- All entries conform to the `#GitRepo` schema

### 3. Multi-Layer Unification

Unify multiple data sources that all conform to the schema:

```cue
config: {
    repo: intention.repo   // Schema constraint
    repo: definition.repo  // Static YAML data
    repo: application.repo // Live API data
}
```

CUE validates that all layers are compatible and produces a unified view.

### Examples

**Single-level inventory** (`repo:`):

- Schema: `intention/repo.cue` defines `#GitRepo`
- Constraint: `repo: [NAME=string]: #GitRepo & { name: NAME }`
- Data layers: definition (YAML), application (GitHub API)

**Multi-level inventory** (`resource:`):

- Schema: `intention/resource.cue` defines `#ConfigMap`
- Constraint: `resource: [NS=string]: [NAME=string]: #ConfigMap & { ... }`
- Indexed by namespace, then name (e.g., `resource.default.dev`)
- Data layer: execution (Kubernetes manifests)

### Benefits

1. **Type Safety**: All data validated against schemas at unification time
2. **Multi-Source**: Combine static config, build outputs, and live API data
3. **Consistency**: Key constraints ensure inventory keys match item identities
4. **Extensibility**: New data sources added by unifying additional layers

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
