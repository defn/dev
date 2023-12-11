package common

import (
	"encoding/yaml"
)

output: {
	"chart/Chart.yaml": """
        # managed by Cue
        \(yaml.Marshal(chart))
        """
	"gen/argocd.yaml":  """
        # managed by Cue
        \(yaml.Marshal(argocd))
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
