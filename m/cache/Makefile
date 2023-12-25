init:
	install -d -m 0750 -o ubuntu -g ubuntu ~/work/registry/certs
	cd ~/work/registry/certs && step certificate create --subtle --insecure --no-password --force --profile self-signed $(uname -n) registry.crt registry.key

up:
	docker-compose up
