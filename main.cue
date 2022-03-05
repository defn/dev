package build

import (
	"github.com/defn/boot"
	"github.com/defn/boot/docker"
)

bootContext: boot.#Boot & {
	greeting: "hey"
}

dockerContext: docker.#Docker & {
	image: "defn/dev"
}
