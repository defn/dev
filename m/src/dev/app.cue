package app

import (
	"github.com/defn/dev/m/common"
)

app: common & {
	chart: name: "src--dev"

	value: {
		registry: "cache.defn.run:5000"
		host:     "\(chart.name).district.amanibhavam.defn.run"
	}
}
