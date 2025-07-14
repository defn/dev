# Initialize cache directories and SSL certificates
# Dependencies: sudo privileges, install command, id command, step command, uname command
# Outputs: Created ~/work/registry/certs directory with proper ownership, created ~/work/bazel-cache directory, generated self-signed SSL certificates (registry.crt, registry.key)
init:
	sudo install -d -D -m 0750 -o $(shell id -un) -g $(shell id -gn) ~/work/registry/certs
	install -d -D -m 0750 -o $(shell id -un) -g $(shell id -gn) ~/work/bazel-cache
	cd ~/work/registry/certs && step certificate create --subtle --insecure --no-password --force --profile self-signed $(shell uname -n) registry.crt registry.key

# Start Docker compose services
# Dependencies: docker command, docker-compose.yml file
# Outputs: Started Docker compose services in detached mode, removed orphaned containers
up:
	docker compose up -d --remove-orphans

# Expose cache services via Tailscale
# Dependencies: tailscale command, running services on localhost:9093 and localhost:4999
# Outputs: Exposed TCP service on port 9002 (proxying to localhost:9093), exposed HTTPS service on port 5000 (proxying to localhost:4999)
serve:
	tailscale serve --tcp 9002 --bg --yes tcp://localhost:9093
	tailscale serve --https 5000 --bg --yes https+insecure://localhost:4999/
