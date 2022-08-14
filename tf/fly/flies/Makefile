%:
	-flyctl secrets set -a $@ --detach \
		DEFN_DEV_TAILSCALE_STATE="$$(pass tailscale_$@)" \
		DEFN_DEV_HOST="$@.tiger-mamba.ts.net" \
		PASSWORD="$$(pass pass-code-server)"
	flyctl deploy -a $@ --remote-only --config app.toml

password:
	flyctl ssh console -a "$(name)" -C "cat /home/ubuntu/.config/code-server/config.yaml"

proxy-docker:
	$(MAKE) so
	while true; do flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2375:2375; sleep 1; done