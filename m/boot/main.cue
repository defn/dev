package boot

import (
	"github.com/defn/dev/m/boot/project"
)

#BootContext: {
	project.#Project
}

bootContext: #BootContext & {
	codeowners: ["@defnn", "@amanibhavam"]
}
