%:
	rsync -ia ~/.password-store/ .password-store
	flyctl secrets set -a $@ --detach DEFN_DEV_TAILSCALE_STATE="$$(pass tailscale_$@)" 
	flyctl deploy -a $@ --remote-only --config app.toml
