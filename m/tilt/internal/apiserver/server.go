package apiserver

import (
	"k8s.io/client-go/rest"
)

// Config holds the apiserver configuration needed by controllers.
type Config struct {
	// LoopbackClientConfig is the config for connecting back to this apiserver.
	LoopbackClientConfig *rest.Config
}
