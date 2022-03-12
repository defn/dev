package dev

import (
	"github.com/defn/boot/docker"
	"github.com/defn/boot/project"
)

#DevContext: {
	docker.#Docker
	project.#Project
}

devContext: #DevContext & {
	image: "defn/dev"
	codeowners: ["@jojomomojo", "@amanibhavam"]
}
