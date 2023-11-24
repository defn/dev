package dev

import (
	"encoding/yaml"
	"strings"
)

output: {
	"Chart.yaml": """
        # managed by Cue
        \(yaml.Marshal(chart))
        """
	"app.yaml":   """
        # managed by Cue
        \(yaml.Marshal(app))
        """

	"deploy.yaml": """
        # managed by Cue
        \(yaml.Marshal(deploy))
        """

	for t, v in template {
		"templates/\(t)": """
			# managed by Cue
			\(yaml.Marshal(v))
			"""
	}
}

output_filenames: strings.Join([
			for o, _ in output {o},
], " ")
