login:
	if ! flyctl auth whoami; then flyctl auth login; fi

start-docker:
	date > docker/.time
	cd docker && flyctl deploy --now || true
	cd docker && flyctl scale count 0

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
