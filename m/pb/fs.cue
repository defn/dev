package pb

import (
	"encoding/yaml"
)

fs: [FILENAME=string]: string

fs: {
	for name, pb in playbook {
		"playbooks/\(name).yaml": yaml.MarshalStream([pb])
	}

	for name, rl in role {
		"roles/\(name)/tasks/main.yaml": yaml.MarshalStream([rl.tasks])
	}
}
