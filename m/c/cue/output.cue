package dev

import (
	"encoding/yaml"
)

output: {
	"chart/Chart.yaml": """
        # managed by Cue
        \(yaml.Marshal(chart))
        """
	"gen/app.yaml":     """
        # managed by Cue
        \(yaml.Marshal(app))
        """

	"gen/deploy.yaml": """
        # managed by Cue
        \(yaml.Marshal(deploy))
        """

	for t, v in template {
		"chart/templates/\(t)": """
			# managed by Cue
			\(yaml.Marshal(v))
			"""
	}
}
