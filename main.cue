package dev

import (
	"github.com/defn/boot/docker"
	"github.com/defn/boot/project"
	"github.com/defn/boot/devcontainer"
)

#DevContext: {
	docker.#Docker
	project.#Project
	devcontainer.#DevContainer
}

devContext: #DevContext & {
	image: "defn/dev"

	codeowners: ["@jojomomojo", "@amanibhavam"]
}
