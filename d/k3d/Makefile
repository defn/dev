build:
	wget -O- https://pkgs.tailscale.com/stable/tailscale_1.28.0_amd64.tgz | tar xvfz -
	kustomize build --enable-helm ../../k/argocd > argocd.yaml
	cp ../../e/k3d-$(name).yaml argocd-appset.yaml
	docker build -t defn.dev/defn/k3d --build-arg DEFN_DEV_ARCHIVE=${DEFN_DEV_ARCHIVE} .

mint:
	docker run --rm -ti --privileged --entrypoint sh quay.io/defn/dev -c \
		"sudo mkdir -p /var/lib/tailscale; \
		sudo /usr/sbin/tailscaled -statedir /var/lib/tailscale & \
		sudo /usr/bin/tailscale up -hostname $(name) -authkey $$(pass tailscale_$(key));  \
		sleep 10; \
		while true; do if sudo test -f /var/lib/tailscale/tailscaled.state; then (echo -n 'STATE '; sudo cat /var/lib/tailscale/tailscaled.state | base64 -w 0); break; fi; sleep 1; done;" | grep ^STATE | awk '{print $$2}' | pass insert -e -f tailscale_$(name)
