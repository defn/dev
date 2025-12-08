package shlex

import (
	"go.starlark.net/starlark"

	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"

	"al.essio.dev/pkg/shellescape"
)

type Plugin struct{}

func NewPlugin() Plugin {
	return Plugin{}
}

func (Plugin) OnStart(env *starkit.Environment) error {
	return env.AddBuiltin("shlex.quote", quote)
}

func quote(thread *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var s string
	err := starkit.UnpackArgs(thread, fn.Name(), args, kwargs,
		"name", &s)
	if err != nil {
		return nil, err
	}

	return starlark.String(shellescape.Quote(s)), nil
}
