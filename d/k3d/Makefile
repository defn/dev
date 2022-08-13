build:
	wget -O- https://pkgs.tailscale.com/stable/tailscale_1.28.0_amd64.tgz | tar xvfz -
	docker build -t defn.dev/defn/k3d .
	rm -f tailscaled.state

get-state:
	pass tailscale_$(name) | base64 -d > tailscaled.state

mint:
	docker run --rm -ti --privileged --entrypoint sh defn/dev -c \
		"mkdir -p /var/lib/tailscale; \
		/tailscaled -statedir /var/lib/tailscale & \
		/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key));  \
		sleep 10; \
		while true; do if test -f /var/lib/tailscale/tailscaled.state; then (echo -n 'STATE '; cat /var/lib/tailscale/tailscaled.state | base64 -w 0); break; fi; sleep 1; done;" | grep ^STATE | awk '{print $$2}' | pass insert -e -f tailscale_$(name)
