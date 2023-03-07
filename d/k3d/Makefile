DEFN_DEV_FROM ?= quay.io/defn/dev:latest-k3d

build:
	rm -f defn-dev-*.yaml
	touch defn-dev-bootstrap.yaml
	if test -d $(app)/bootstrap/$(name); then \
		kustomize build --enable-helm $(app)/bootstrap/$(name) > defn-dev-bootstrap.yaml; \
		fi
	if test -f $(app)/e/$(name).yaml; then \
		cp $(app)/e/$(name).yaml defn-dev-egg.yaml; \
		fi
	docker build -t 169.254.32.1:5000/defn/k3d:$(name) --build-arg DEFN_DEV_ARCHIVE="$(DEFN_DEV_ARCHIVE)" --build-arg DEFN_DEV_FROM="$(DEFN_DEV_FROM)" .
	rm -f defn-dev-*.yaml

mint:
	docker run --rm -ti --privileged --entrypoint sh quay.io/defn/dev:latest-dev -c \
		"sudo mkdir -p /var/lib/tailscale; \
		sudo /usr/sbin/tailscaled -statedir /var/lib/tailscale & \
		sudo /usr/bin/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key)); \
		sleep 10; \
		while true; do if sudo test -f /var/lib/tailscale/tailscaled.state; then domain=\`tailscale cert 2>&1 | grep ' use ' | cut -d'\"' -f2\`; sudo tailscale cert \$$domain; sudo tar cf - /var/lib/tailscale/tailscaled.state /var/lib/tailscale/certs | base64 -w 0; break; fi; sleep 1; done;" | tail -1 | pass insert -e -f tailscale_$(name)

min:
	docker run --rm -ti --privileged --entrypoint sh quay.io/defn/dev:latest-dev -c \
		"sudo mkdir -p /var/lib/tailscale; \
		sudo /usr/sbin/tailscaled -statedir /var/lib/tailscale & \
		sudo /usr/bin/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key)); \
		sleep 10; \
		while true; do if sudo test -f /var/lib/tailscale/tailscaled.state; then sudo tar cf - /var/lib/tailscale/tailscaled.state | base64 -w 0; break; fi; sleep 1; done;" | tail -1 | pass insert -e -f tailscale_$(name)
