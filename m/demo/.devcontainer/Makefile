envbuilder:
	docker run -it --rm \
		-v /home:/workspaces \
		-v envbuilder-image:/image-cache:ro \
		-v envbuilder-layer:/layer-cache \
		-v /nix:/nix \
		-v /home/ubuntu:/home/ubuntu \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e LAYER_CACHE_DIR=/layer-cache \
		-e BASE_IMAGE_CACHE_DIR=/image-cache \
		-e GIT_URL=https://github.com/defn/dev \
		-e INIT_SCRIPT=bash \
		-e DEVCONTAINER_DIR=m/demo/.devcontainer \
		ghcr.io/coder/envbuilder
