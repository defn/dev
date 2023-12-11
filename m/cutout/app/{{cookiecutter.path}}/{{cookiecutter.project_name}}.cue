package app

import (
	"github.com/defn/dev/m/common"
)

app: common & {
  chart: name: "{{cookiecutter.project_name}}"

  value: {
    registry: "cache.defn.run:5000"
    host:     "\(app.chart.name).district.amanibhavam.defn.run"
  }
}
