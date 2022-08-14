%:
	-flyctl secrets set -a $@ --detach DEFN_DEV_TAILSCALE_STATE="$$(pass tailscale_$@)" 
	flyctl deploy -a $@ --remote-only --config app.toml

password:
	flyctl ssh console -a "$(name)" -C "cat /home/ubuntu/.config/code-server/config.yaml"