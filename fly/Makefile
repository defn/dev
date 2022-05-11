login:
	if ! flyctl auth whoami; then flyctl auth login; fi
	unset DOCKER_HOST; flyctl auth docker

start-docker:
	date > docker/.time
	cd docker && flyctl deploy --remote-only || true
	cd docker && flyctl scale count 0

ping-docker:
	while true; do $(MAKE) start-docker; sleep 540; done

trigger-docker:
	socat TCP-LISTEN:2375,reuseaddr,fork,max-children=4 EXEC:"'bash -c \"(if ! netcat -z localhost 2377; then $(MAKE) start-docker; sleep 5; fi) 1>/dev/null 2>&1; socat - "TCP:localhost:2377\""'",nofork

proxy:
	while true; do flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2377:2375; sleep 1; done

defnx:
	flyctl deploy --remote-only --config $@.toml
	while sudo ping -c1 defn; do :; done
	sleep 15
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu

defn0:
	flyctl scale --app defn count 0

up:
	flyctl scale --app so count 1
	flyctl scale --app the count 1

down:
	flyctl scale --app so count 0
	flyctl scale --app the count 0

defn1:
	flyctl scale --app defn count 1
	until sudo ping -c1 defn; do :; done
	code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu

%:
	flyctl deploy --remote-only --config $@.toml
