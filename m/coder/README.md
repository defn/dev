```
sudo tailscale up --accept-dns=true --advertise-routes 10.43.0.0/16 --operator ubuntu  --ssh && tailscale funnel 443 on && mkdir -p ~/m/c/dfd/openid && tailscale serve https /openid ~/m/c/dfd/openid && tailscale serve status
```
