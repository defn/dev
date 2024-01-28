package report

import (
	"github.com/defn/dev/m/pb/inventory/dump"
)

cpu: {
	for h, i in dump.host {
		(h): "\(i.ansible_processor_nproc) \(i.ansible_processor[1]) \(i.ansible_processor[2])"
	}
}
