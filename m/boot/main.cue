package boot

import (
	"github.com/defn/m/boot/project"
)

#BootContext: {
	project.#Project
}

bootContext: #BootContext & {
	codeowners: ["@defnn", "@amanibhavam"]
}
