%:
	-flyctl secrets set -a $@ --detach \
		DEFN_DEV_TAILSCALE_STATE="$$(pass tailscale_$@)" \
		DEFN_DEV_HOST="$@.tiger-mamba.ts.net" \
		PASSWORD="$(pass pass-code-server)"
	flyctl deploy -a $@ --remote-only --config app.toml

password:
	flyctl ssh console -a "$(name)" -C "cat /home/ubuntu/.config/code-server/config.yaml"