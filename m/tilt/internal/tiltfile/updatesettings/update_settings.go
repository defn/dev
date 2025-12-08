package updatesettings

import (
	"fmt"

	"github.com/pkg/errors"
	"go.starlark.net/starlark"

	"github.com/defn/dev/m/tilt/pkg/model"

	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"
)

// Implements functions for dealing with update settings.
type Plugin struct{}

func NewPlugin() Plugin {
	return Plugin{}
}

func (e Plugin) NewState() interface{} {
	return model.DefaultUpdateSettings()
}

func (e Plugin) OnStart(env *starkit.Environment) error {
	return env.AddBuiltin("update_settings", e.updateSettings)
}

func (e *Plugin) updateSettings(thread *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var maxParallelUpdates starlark.Value
	if err := starkit.UnpackArgs(thread, fn.Name(), args, kwargs,
		"max_parallel_updates?", &maxParallelUpdates); err != nil {
		return nil, err
	}

	mpu, mpuPassed, err := valueToInt(maxParallelUpdates)
	if err != nil {
		return nil, errors.Wrap(err, "update_settings: for parameter \"max_parallel_updates\"")
	}
	if mpuPassed && mpu < 1 {
		return nil, fmt.Errorf("max number of parallel updates must be >= 1(got: %d)",
			maxParallelUpdates)
	}

	err = starkit.SetState(thread, func(settings model.UpdateSettings) model.UpdateSettings {
		if mpuPassed {
			settings = settings.WithMaxParallelUpdates(mpu)
		}
		return settings
	})

	return starlark.None, err
}

func valueToInt(v starlark.Value) (val int, wasPassed bool, err error) {
	switch x := v.(type) {
	case nil, starlark.NoneType:
		return 0, false, nil
	case starlark.Int:
		val, err := starlark.AsInt32(x)
		return val, true, err
	default:
		return 0, true, fmt.Errorf("got %T, want int", x)
	}
}

var _ starkit.StatefulPlugin = Plugin{}

func MustState(model starkit.Model) model.UpdateSettings {
	state, err := GetState(model)
	if err != nil {
		panic(err)
	}
	return state
}

func GetState(m starkit.Model) (model.UpdateSettings, error) {
	var state model.UpdateSettings
	err := m.Load(&state)
	return state, err
}
