login:
	cd ~/.password-store && git-crypt unlock
	if ! flyctl auth whoami; then flyctl auth login; fi
	unset DOCKER_HOST; flyctl auth docker

proxy-docker:
	while true; do flyctl --app "$(shell flyctl apps list | grep 'fly-builder' | awk '{print $$1}' | head -1)" proxy 2377:2375; sleep 1; done

socat-docker:
	socat \
		TCP-LISTEN:2375,reuseaddr,fork,max-children=8 \
		EXEC:"'socat - TCP:localhost:2377'",nofork

%:
	flyctl deploy --remote-only --config $@.toml
