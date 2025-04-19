package k3d

import (
	"encoding/yaml"
	"tool/cli"
)

objects: [
	for app, a_ele in kube
	for type, t_ele in a_ele
	for name, ele in t_ele {
		ele
	},
]

command: dump: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(objects)
	}
}
