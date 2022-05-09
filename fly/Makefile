login:
	if ! flyctl auth whoami; then flyctl auth login; fi
	flyctl auth docker

start-docker:
	date > docker/.time
	cd docker && flyctl deploy --remote-only || true
	cd docker && flyctl scale count 0

ping-docker:
	while true; do $(MAKE) start-docker; sleep 540; done

tunnel-docker:
	socat tcp-listen:2375,reuseaddr,fork,bind=$(shell tailscale ip -4) tcp:localhost:2375

proxy:
	flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2375:2375

defn:
	flyctl deploy --remote-only --config $@.toml
	while sudo ping -c1 defn; do :; done
	sleep 15
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu

defn0:
	flyctl scale --app defn count 0

defn1:
	flyctl scale --app defn count 1
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu

%:
	flyctl deploy --remote-only --config $@.toml
