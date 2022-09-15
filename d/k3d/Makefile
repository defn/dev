build:
	wget -O- https://pkgs.tailscale.com/stable/tailscale_1.30.0_amd64.tgz | tar xvfz -
	if test -d $(app)/bootstrap/$(name); then kustomize build --enable-helm $(app)/bootstrap/$(name) > defn-dev-bootstrap.yaml; else echo > defn-dev-bootstrap.yaml; fi
	if test -d $(app)/bootstrap/$(name); then cp $(app)/e/$(name).yaml defn-dev-argocd-appset.yaml; fi
	docker build -t defn.dev/defn/k3d:$(app) --build-arg DEFN_DEV_ARCHIVE="${DEFN_DEV_ARCHIVE}" .

mint:
	docker run --rm -ti --privileged --entrypoint sh quay.io/defn/dev -c \
		"sudo mkdir -p /var/lib/tailscale; \
		sudo /usr/sbin/tailscaled -statedir /var/lib/tailscale & \
		sudo /usr/bin/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key));  \
		sleep 10; \
		while true; do if sudo test -f /var/lib/tailscale/tailscaled.state; then domain=\`tailscale cert 2>&1 | grep ' use ' | cut -d'\"' -f2\`; sudo tailscale cert \$$domain; sudo tar cf - /var/lib/tailscale/tailscaled.state /var/lib/tailscale/certs | base64 -w 0; break; fi; sleep 1; done;" | tail -1 | pass insert -e -f tailscale_$(name)

min:
	docker run --rm -ti --privileged --entrypoint sh quay.io/defn/dev -c \
		"sudo mkdir -p /var/lib/tailscale; \
		sudo /usr/sbin/tailscaled -statedir /var/lib/tailscale & \
		sudo /usr/bin/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key));  \
		sleep 10; \
		while true; do if sudo test -f /var/lib/tailscale/tailscaled.state; then sudo tar cf - /var/lib/tailscale/tailscaled.state | base64 -w 0; break; fi; sleep 1; done;" | tail -1 | pass insert -e -f tailscale_$(name)
