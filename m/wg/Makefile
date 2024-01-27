wiredialer:
	chmod 0600 wg1.conf
	b build
	$(shell git rev-parse --show-toplevel)/m/bazel-bin/wg/wg_/wg wg1.conf https://kubernetes.default.svc.cluster.local:443

proxy:
	chmod 0600 wg2.conf
	(sleep 2; $(MAKE) client) &
	wireproxy --config wg2.conf

client:
	curl -s -k -H "Authorization: Bearer $$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://127.0.0.1:25565/api/v1/namespaces | jq -r '.items[].metadata.name' | sort

up:
	chmod 0600 wg0.conf
	sudo wg-quick up ./wg0.conf

down:
	sudo wg-quick down wg0