# ACUTE - Accumulate, Configure, Unify, Transform, Execute

ACUTE is a self-refining data pipeline that transforms platform operations into a continuous learning system. It ingests all aspects of infrastructure—code, configuration, runtime state, and external APIs—unifies them into a formal CUE lattice, and generates optimized actions. When execution outputs feed back as inputs to the next cycle, the system creates a continuous refinement loop.

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

The five-phase pipeline processes these layers:

1. **Accumulate** - Ingest everything: git contents, cloud state, API responses, tool outputs
2. **Configure** - Normalize and index disparate data, relate isolated information
3. **Unify** - Merge into CUE lattice where constraints compose and conflicts surface
4. **Transform** - Generate concrete tool inputs: manifests, Terraform configs, scripts
5. **Execute** - Run tools, deploy changes, capture outputs for next cycle

When Execute changes the world (kubectl apply, terraform apply), the next Accumulate captures that changed state through Application layer queries. Comparing Execution (planned) vs. Application (actual) automatically detects drift.

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

The lattice in `main.cue` unifies all four knowledge layers with their schemas. CUE validates that everything is consistent and type-safe.

## Current State

**Working:**

- ACUTE pipeline runs and validates across all phases
- IDEA ontology implemented: all four knowledge layers exist
- CUE lattice unifies ~19k lines of validated configuration
- Manages 14 AWS organizations with ~145 accounts
- Generates Terraform, AWS configs, documentation from unified source

**In Progress:**

- Accumulate currently ingests: GitHub repos, Kustomize manifests, YAML configs
- Execute builds documentation but doesn't deploy infrastructure yet
- Feedback loop not closed: outputs written but not committed to git

**Planned:**

- Execute will deploy via kubectl (ArgoCD bootstrap) and Terraform
- Accumulate will expand to ingest full Application layer state
- Continuous cycling: each execution feeds next accumulation
- Drift detection: automatic comparison of planned vs. actual state

## External Systems (Application Layer)

ACUTE accumulates state from external systems to detect drift and inform optimization. Currently ingesting:

- **GitHub** - Repository metadata
- **Kubernetes** - Kustomize build outputs (planned: live cluster state via kubectl)
- **AWS** - Account definitions (planned: resource state via AWS APIs)

Planned accumulation sources:

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

The system is designed to run continuously. Each cycle:

1. **Accumulate** ingests current state of the world (Application) and what tools plan (Execution)
2. **Unify** detects drift when planned ≠ actual
3. **Transform** generates corrective actions
4. **Execute** applies changes and commits results to git
5. Next cycle's **Accumulate** ingests those commits → the loop closes

This creates two operational modes:

**Continuous Equilibrium (CE)** - React to the world's response. When a server fails or configuration drifts, detect it in Application layer and generate corrective Execution. The system maintains stability through continuous intervention.

**Continuous Annealing (CA)** - Refine based on patterns. When CE repeatedly corrects the same drift, analyze the pattern and update Intentions (schemas) to match what reality proves optimal. The system evolves toward configurations that naturally stay in equilibrium.

This is planned work. Currently the pipeline runs manually and outputs aren't committed back to git. Once the loop closes, ACUTE becomes a continuous sensemaking system that learns from execution.
