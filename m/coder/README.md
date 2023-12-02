```
once:
- create c/CLUSTER/ cue cnfig
- create secrets for CLUSTER

automate:
update postgres coder secret

tailscale up --advertise-routes=$(k get -n traefik svc traefik -o json | jq -r '.spec.clusterIP')/32 --accept-routes --ssh

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->