package build

import (
	"github.com/defn/boot/docker"
)

dockerContext: docker.#Docker & {
	image: "defn/dev"
}
