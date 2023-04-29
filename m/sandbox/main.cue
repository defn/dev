package sandbox

import (
	core "github.com/defn/dev/m/boot/k8s/api/core/v1"
)

#MyService: core.#Service & {
	metadata: name: "mine"
}
