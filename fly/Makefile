login:
	cd ~/.password-store && git-crypt unlock
	if ! flyctl auth whoami; then flyctl auth login; fi
	unset DOCKER_HOST; flyctl auth docker

start-docker:
	date > docker/.time
	cd docker && flyctl deploy --remote-only || true
	cd docker && flyctl scale count 0

trigger-docker:
	socat \
		TCP-LISTEN:2375,reuseaddr,fork,max-children=8 \
		EXEC:"'socat - TCP:localhost:2377'",nofork

trigger-devcontainer:
	socat \
		TCP-LISTEN:2222,reuseaddr,fork,max-children=4 \
		EXEC:"'bash -c \"(flyctl scale --app defn count 1; while ! netcat -z defn 22; do sleep 1; done) 1>/dev/null 2>&1; socat - TCP:defn:22\"'",nofork

proxy:
	while true; do flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2377:2375; sleep 1; done

up:
	@true

down:
	-flyctl scale --app defn count 0

%:
	flyctl deploy --remote-only --config $@.toml
