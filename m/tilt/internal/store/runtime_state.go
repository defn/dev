package store

import (
	"fmt"
	"time"

	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
)

type RuntimeState interface {
	RuntimeState()

	// There are two types of resource dependencies:
	// - servers (Deployments) where what's important is that the server is running
	// - tasks (Jobs, local resources) where what's important is that the job completed
	// Currently, we don't try to distinguish between these two cases.
	//
	// In the future, it might make sense to check "IsBlocking()" or something,
	// and alter the behavior based on whether the underlying resource is a server
	// or a task.
	HasEverBeenReadyOrSucceeded() bool

	RuntimeStatus() v1alpha1.RuntimeStatus

	// If the runtime status is in Error mode,
	// RuntimeStatusError() should report a reason.
	RuntimeStatusError() error
}

type LocalRuntimeState struct {
	CmdName                  string
	Status                   v1alpha1.RuntimeStatus
	PID                      int
	StartTime                time.Time
	FinishTime               time.Time
	SpanID                   model.LogSpanID
	LastReadyOrSucceededTime time.Time
	Ready                    bool
}

var _ RuntimeState = LocalRuntimeState{}

func (LocalRuntimeState) RuntimeState() {}

func (l LocalRuntimeState) RuntimeStatus() v1alpha1.RuntimeStatus {
	status := l.Status
	if status == "" {
		status = v1alpha1.RuntimeStatusUnknown
	}
	return status
}

func (l LocalRuntimeState) RuntimeStatusError() error {
	status := l.RuntimeStatus()
	if status != v1alpha1.RuntimeStatusError {
		return nil
	}
	return fmt.Errorf("Process %d exited with non-zero status", l.PID)
}

func (l LocalRuntimeState) HasEverBeenReadyOrSucceeded() bool {
	return !l.LastReadyOrSucceededTime.IsZero()
}
