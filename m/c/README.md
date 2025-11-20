# ACUTE - Accumulate, Configure, Unify, Transform, Execute

ACUTE is a self-refining data pipeline that transforms platform operations into continuous learning. It ingests all aspects of infrastructure—code, configuration, runtime state, and external APIs—then unifies them into a formal CUE lattice to generate validated actions. When execution outputs feed back as inputs to the next cycle, an ouroboros emerges: the system refines itself through observation.

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

## How It Works

ACUTE operates on four layers of knowledge (IDEA):

- **Intentions** - Theoretical knowledge: CUE schemas, governance policies, constraints
- **Definitions** - Direct knowledge: git repos, declared configurations, static data
- **Execution** - Derived knowledge: what tools plan to deploy (kustomize build, terraform plan)
- **Application** - Indirect knowledge: what's actually running (kubectl get, AWS state, GitHub API)

Five phases form an Ouroboros Pipeline:

1. **Accumulate** - Ingest everything: git contents, cloud state, API responses, tool outputs
2. **Configure** - Normalize and index into queryable structures (the data lake)
3. **Unify** - Merge into CUE lattice where constraints compose and conflicts surface automatically
4. **Transform** - Generate concrete tool inputs: manifests, Terraform configs, deployment scripts
5. **Execute** - Apply changes, capture outputs that seed the next cycle

Drift emerges naturally from comparing Execution (planned) against Application (actual). Each cycle observes reality, validates against intentions, and generates corrections.

## Directory Structure

```
c/
├── intention/      # Schemas: what should be true
├── definition/     # Static config: what you declared
├── execution/      # Derived outputs: what tools computed
├── application/    # Live state: what exists in the world
├── docs/           # Generated documentation site
├── main.cue        # Unifies all layers into lattice
└── *.sh            # Pipeline phase scripts
```

The lattice in `main.cue` unifies all four knowledge layers with their schemas. CUE's constraint logic ensures everything is consistent and type-safe before any action executes.

## Current State

**Working:**

- ACUTE pipeline runs and validates across all phases
- IDEA ontology implemented: all four knowledge layers exist
- CUE lattice unifies ~19k lines of validated configuration
- Manages 14 AWS organizations with ~145 accounts
- Generates Terraform, AWS configs, documentation from unified source

**In Progress:**

- Accumulate ingests GitHub repos, Kustomize manifests, and YAML configs
- Execute builds documentation but doesn't yet deploy infrastructure
- Outputs written but not committed back to git (loop not closed)

**Planned:**

- Deploy via kubectl (ArgoCD bootstrap) and Terraform
- Expand accumulation to full Application layer state
- Close the loop: commit execution outputs to seed next accumulation

## External Systems (Application Layer)

ACUTE observes state from external systems to detect drift and guide optimization. Currently ingesting:

- **GitHub** - Repository metadata
- **Kubernetes** - Kustomize build outputs (planned: live cluster state via kubectl)
- **AWS** - Account definitions (planned: resource state via AWS APIs)

Planned accumulation sources:

- **Terraform** - State outputs, resource attributes
- **Buildkite** - CI/CD pipeline state, build results
- **ArgoCD** - Kubernetes deployment state, sync status
- **Coder** - Workspace state, template versions
- **Tailscale** - Network mesh state, device connectivity
- **Cloudflare** - Workers/Pages deployments, edge configuration
- **GCP** - BigQuery datasets, project resources
- **Google Workspace** - Users, groups (for BigQuery IAM integration)
- **Docker Registry** (ghcr.io) - Container images, manifests

These sources can be queried directly via CLIs or unified through tools like Steampipe for SQL-based accumulation.

## The Continuous Refinement Loop

When fully closed, the system enables two operational modes:

**Continuous Equilibrium (CE)** - React to environmental changes. When infrastructure fails or configuration drifts, generate corrective actions to maintain stability.

**Continuous Annealing (CA)** - Learn from patterns. When CE repeatedly corrects the same drift, update Intentions (schemas) to match what reality proves optimal. The system evolves toward configurations that naturally maintain equilibrium.

This is planned work. Currently the pipeline runs manually and doesn't commit outputs back to git. Once the ouroboros closes, ACUTE becomes a sensemaking system that learns from its own execution.
