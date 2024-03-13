mkdir -p $HOME/.docker/cli-plugins
wget https://github.com/docker/buildx/releases/download/v0.13.1/buildx-v0.13.1.linux-amd64
chmod +x buildx-v0.13.1.linux-amd64
mv buildx-v0.13.1.linux-amd64 $HOME/.docker/cli-plugins/docker-buildx

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
