package app

import (
	"github.com/defn/dev/m/common"
)

app: common & {
	chart: name: "{{cookiecutter.project_name}}"

	value: {
		registry: "coder-amanibhavam-district.tail3884f.ts.net:5000"
		host:     "\(chart.name).district.amanibhavam.defn.run"
	}
}
