# CRD Generation

This directory contains CUE schemas that generate both Kubernetes CRDs and TypeScript types.

## File Structure

```
User-edited (source):
├── api.cue             # CRD template definitions
└── api.Script.cue      # Script schema definition

Auto-generated (intermediate):
├── api.Script.yaml     # OpenAPI spec from CUE

Auto-generated (output):
├── crd.Script.yaml     # Kubernetes CRD manifest
└── Script.d.ts         # TypeScript types
```

## Generation Pipeline

```
api.Script.cue ─┬─► api.Script.yaml ─┬─► crd.Script.yaml (for kubectl apply)
                │                    │
                │                    └─► Script.d.ts (for TypeScript imports)
                │
api.cue ────────┘
```

1. `cue def` exports the CUE schema to OpenAPI YAML
2. `openapi-typescript` generates TypeScript types from OpenAPI
3. `cue export` generates the Kubernetes CRD manifest with injected schema

## Usage

```bash
mise run gen
```

## Adding a New CRD

1. Create `api.NewKind.cue` with the schema definition
2. Add the CRD metadata to `api.cue`
3. Add `NewKind` to the loop in `.mise/tasks/gen`
4. Run `mise run gen`
