domain ?= tiger-mamba.ts.net

%:
	rm -rf tmp
	mkdir tmp
	mkdir -p tmp/$@/var/lib/tailscale
	(cd tmp/$@ && pass tailscale_$@ | base64 -d | tar xvf -)
	-flyctl secrets set -a $@ --detach \
		DEFN_DEV_ARCHIVE="$$(cd tmp/$@ && tar cvf - . | base64 | xargs | sed 's# ##g')" \
		DEFN_DEV_HOST="$@.$(domain)" \
		PASSWORD="$$(pass pass-code-server)"
	flyctl deploy -a $@ --remote-only --config app.toml

password:
	flyctl ssh console -a "$(name)" -C "cat /home/ubuntu/.config/code-server/config.yaml"

proxy-docker:
	$(MAKE) so
	while true; do flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2375:2375; sleep 1; done