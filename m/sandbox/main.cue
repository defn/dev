package sandbox

import (
	core "github.com/defn/m/boot/k8s/api/core/v1"
)

#MyService: core.#Service & {
	metadata: name: "mine"
}
