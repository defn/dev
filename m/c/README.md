# ACUTE - Accumulate, Configure, Unify, Transform, Execute

ACUTE is a configuration and infrastructure management system that uses CUE as a unified source of truth.

## Quick Start

Run all phases with mise:

```bash
cd c/
mise
```

Or run phases individually:

```bash
./accumulate.sh   # Gather raw data
./configure.sh    # Process data
./unify.sh        # Validate and consolidate
./transform.sh    # Generate tool-specific formats
./execute.sh      # Build outputs
```

## Architecture

ACUTE implements a five-phase pipeline:

1. **Accumulate** - Gather raw data from multiple sources (APIs, files, commands)
2. **Configure** - Process and prepare data for optimal unification
3. **Unify** - Apply schemas and consolidate data into unified CUE
4. **Transform** - Convert CUE to tool-specific formats (YAML, JSON, Terraform)
5. **Execute** - Run tools to generate final outputs (docs, infrastructure)

## Directory Structure

```
c/
├── intention/      # CUE schemas (what data should look like)
├── definition/     # Static configuration (YAML files, AWS accounts)
├── application/    # Dynamic data (API responses, GitHub metadata)
├── execution/      # Tool outputs (Kustomize manifests, etc.)
├── docs/           # Generated Astro.js documentation site
├── main.cue        # Unifies all sources with schemas
└── *.sh            # Pipeline phase scripts
```

### Core Concepts

**CUE Packages:** Each directory is a CUE package containing schemas (intention) or data (definition, application, execution).

**Unification:** `main.cue` combines schemas with data from all sources. CUE validates that data conforms to schemas.

**Data Layers:**

- **intention/** - Schemas defining structure and constraints
- **definition/** - Static configuration (AWS accounts, repos)
- **application/** - API-sourced data (GitHub metadata)
- **execution/** - Tool-generated outputs (Kustomize)

**Generated Outputs:**

- `main.yaml` - Unified configuration (Unify phase)
- `docs/src/content/aws/` - AWS account YAML files (Transform phase)
- `docs/dist/` - Built documentation site (Execute phase)

See [docs/README.md](docs/README.md) for documentation site details.

## Pipeline Phases

### 1. Accumulate

```bash
./accumulate.sh
```

Runs `accum.sh` scripts in subdirectories to gather raw data:

- `definition/accum.sh` - Converts `repo.yaml` to CUE
- `execution/accum.sh` - Captures Kustomize output
- `application/accum.sh` - Fetches GitHub API data

Each generates a `gen.cue` file with raw data.

### 2. Configure

```bash
./configure.sh
```

Processes accumulated data for optimal unification. Currently a stub for future normalization and enrichment.

### 3. Unify

```bash
./unify.sh
```

Applies schemas and validates data:

- Imports all CUE packages (intention, definition, application, execution)
- Unifies data with schemas in `main.cue`
- Exports to `main.yaml`

### 4. Transform

```bash
./transform.sh
```

Converts CUE to tool-specific formats:

- Generates AWS account YAML files in `docs/src/content/aws/`
- Future: Terraform configs, Ansible playbooks, etc.

### 5. Execute

```bash
./execute.sh
```

Runs tools on transformed data:

- Builds Astro.js documentation site
- Future: Deploy infrastructure with kubectl, Terraform, etc.

## How Unification Works

CUE unifies schemas with data from multiple sources:

```cue
config: {
    resource: intention.resource  // Schema
    resource: execution.resource  // Data (must match schema)

    repo: intention.repo          // Schema
    repo: definition.repo         // Static data
    repo: application.repo        // API data (all must unify)

    aws: intention.aws            // Schema
    aws: definition_aws           // AWS account definitions
}
```

Benefits:

- Validates data against schemas at unification time
- Detects conflicts between data sources
- Ensures type safety and constraints
- Single source of truth across all tools

## Example: AWS Accounts

Input (CUE):

```cue
// definition/aws/aws.cue
config: aws: fogg: ci: {
    account: "ci"
    id: "812459563189"
    email: "fogg-home@defn.sh"
}
```

Output (YAML):

```yaml
# docs/src/content/aws/fogg/ci.yaml
account: ci
id: "812459563189"
email: fogg-home@defn.sh
aws_config: |
  [profile fogg-ci]
  sso_account_id=812459563189
  ...
```

The `aws_config` field is computed by the CUE schema and provides ready-to-use AWS CLI configuration.
