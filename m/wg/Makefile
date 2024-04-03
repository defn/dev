#
server:
	chmod 0600 wg1.conf
	b build
	$(shell git rev-parse --show-toplevel)/m/bazel-bin/wg/wg_/wg wg1.conf http://google.com:80

# proxy one app
proxy:
	chmod 0600 wg2.conf
	wireproxy --config wg2.conf

client:
#	curl -s -k -H "Authorization: Bearer $$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://127.0.0.1:25565 | jq -r '.items[].metadata.name' | sort
	curl -s -k http://127.0.0.1:25565

# kernel wireguard
up:
	chmod 0600 wg0.conf
	sudo wg-quick up ./wg0.conf

down:
	sudo wg-quick down wg0