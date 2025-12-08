package kubernetesdiscovery

import "github.com/defn/dev/m/tilt/internal/store"

type Dispatcher interface {
	Dispatch(action store.Action)
}
