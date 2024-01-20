wiredialer:
	go run main.go wg1.conf https://kubernetes.default.svc.cluster.local:443

proxy:
	(sleep 2; $(MAKE) client) &
	wireproxy --config wg2.conf

client:
	curl -s -k -H "Authorization: Bearer $$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://127.0.0.1:25565/api/v1/namespaces | jq -r '.items[].metadata.name' | sort
