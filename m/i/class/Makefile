all:
	cd ../base && $(MAKE)
	$(MAKE) buildkite
	$(MAKE) class
	$(MAKE) class-latest
	$(MAKE) class-buildkite-latest

reset:
	@echo --- pruning
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	cd ../../cache && docker compose down && $(MAKE) up
	this-prune

class:
	@echo --- earthly 
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	earthly --ci --push --no-output --allow-privileged --secret tsauthkey +class

class-latest:
	@echo --- earthly
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	earthly --ci --push --no-output --allow-privileged --secret tsauthkey +class-latest

class-buildkite-latest:
	@echo --- earthly
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	earthly --ci --push --no-output --allow-privileged --secret tsauthkey +class-buildkite-latest

buildkite:
	@echo --- earthly
	sudo chown ubuntu:ubuntu /var/run/docker.sock
	docker ps || sudo docker ps
	earthly --ci --push --no-output +buildkite
