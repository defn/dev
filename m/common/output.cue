package common

import (
	"encoding/yaml"
)

output: {
	"chart/Chart.yaml": """
        # managed by Cue
        \(yaml.Marshal(chart))
        """
	for t, v in template {
		"chart/templates/\(t)": """
			# managed by Cue
			\(yaml.Marshal(v))
			"""
	}
}
