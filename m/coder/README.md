```
one time:

add oidc identity provider as part of make secrets when funnel is opened
create CLUSTER-cluster iam role

automate:
update postgres coder secret

tailscale up --advertise-routes=$(k get -n traefik svc traefik -o json | jq -r '.spec.clusterIP')/32 --accept-routes --ssh

```
