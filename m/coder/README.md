```
sudo tailscale up --accept-dns=true --advertise-routes 10.43.0.0/16 --operator ubuntu  --ssh && mkdir -p ~/m/c/CLUSTER/openid && tailscale serve https /openid ~/m/c/CLUSTER/openid && tailscale funnel 443 on && tailscale serve status
```
