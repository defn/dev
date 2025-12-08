package cli

import (
	"github.com/tilt-dev/tilt-apiserver/pkg/server/options"
)

// InMemoryCertKey returns a GeneratableKeyCert that generates certs in-memory
// without using a fixture directory. This is needed for Bazel sandbox
// compatibility where runtime.Caller-based paths don't work.
//
// TODO(bazel): The upstream tilt-apiserver testdata.CertKey() uses runtime.Caller
// to find fixture files, which doesn't work in Bazel sandboxes. Consider fixing
// upstream or providing a bazel-compatible alternative.
func InMemoryCertKey() options.GeneratableKeyCert {
	return options.GeneratableKeyCert{}
}
