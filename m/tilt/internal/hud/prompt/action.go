package prompt

import "github.com/defn/dev/m/tilt/internal/store"

type SwitchTerminalModeAction struct {
	Mode store.TerminalMode
}

func (SwitchTerminalModeAction) Action() {}

var _ store.Action = SwitchTerminalModeAction{}
