```
automate:
update postgres coder secret

tailscale up --advertise-routes=$(k get -n traefik svc traefik -o json | jq -r '.spec.clusterIP')/32 --accept-routes --ssh

```
