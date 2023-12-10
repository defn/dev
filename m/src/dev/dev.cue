package app

import (
	"github.com/defn/dev/m/common"
)

app: common
app: chart: name: "dev"

app: value: {
	registry: "cache.defn.run:5000"
	host:     "\(app.chart.name).district.amanibhavam.defn.run"
}
