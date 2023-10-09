```
(cd ~/m/c/r/digest && make cache)
mkdir -p ~/m/c/$(uname -n)/openid && tailscale serve https /openid ~/m/c/$(uname -n)/openid && tailscale funnel 443 on && tailscale serve status
```
