# CUE Configuration System

This directory implements a layered CUE configuration system that separates concerns between schemas, configurations, build artifacts, and API data.

## Directory Structure

### `intention/` - CUE Schemas
Contains CUE schema definitions that define the structure and constraints for configuration data.

- `repo.cue` - Schema for repository definitions
- `resource.cue` - Schema for Kubernetes resources

These schemas define the intended structure of data without providing actual values.

### `definition/` - Configuration Files
Contains concrete configuration data imported from YAML files.

- `gen.cue` - Generated from `repo.yaml` via `ingest-repo.sh`
- Provides actual repository definitions with descriptions and metadata

### `execution/` - Build Scripts
Contains Kubernetes manifests and build-time generated data.

- `gen.cue` - Generated from `kubectl kustomize` output via `ingest-kustomize.sh`
- Captures the actual Kubernetes resources that will be deployed

### `application/` - API Clients
Contains data fetched from external APIs.

- `gen.cue` - Generated from GitHub API via `ingest-github-repo.sh`
- Fetches repository metadata including names, descriptions, URLs, and timestamps

## Ingestion Pipeline

The `ingest.sh` script orchestrates data ingestion across all layers, transforming external data sources into importable CUE packages:

```bash
./ingest.sh
```

This runs three ingestion scripts in sequence:

1. **definition/ingest-repo.sh** - Converts `repo.yaml` to CUE format
2. **execution/ingest-kustomize.sh** - Converts kustomize output to CUE format
3. **application/ingest-github-repo.sh** - Fetches GitHub repo data and converts to CUE

Each ingestion script transforms data (YAML files, command output, or API responses) into properly formatted CUE packages that can be imported and unified with the schema definitions.

After ingestion, it runs `cue eval` to unify all layers.

## Unification Model

The `main.cue` file imports all four packages and unifies them:

```cue
config: {
    resource: intention.resource  // Schema definition
    resource: execution.resource  // Actual resources (unified with schema)

    repo: intention.repo          // Schema definition
    repo: definition.repo         // Configuration data
    repo: application.repo        // API data (unified with schema and config)
}
```

CUE's unification ensures that:
- All `definition` data conforms to `intention` schemas
- All `execution` resources match `intention` schemas
- All `application` data is validated against `intention` schemas
- Conflicts between layers are detected at evaluation time

## Workflow

1. Define schemas in `intention/` that describe your desired structure
2. Add configuration files to `definition/` and related ingestion scripts
3. Generate build artifacts in `execution/` via kustomize or other tools
4. Fetch live API data into `application/` from external sources
5. Run `./ingest.sh` to import all data into CUE format
6. CUE automatically validates and unifies all layers against the schemas

This approach separates concerns while ensuring consistency across configuration sources through CUE's type system and unification semantics.
