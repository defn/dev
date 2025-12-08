package session

import (
	"fmt"
	"strings"
	"time"

	ctrl "sigs.k8s.io/controller-runtime"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/apis"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	session "github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

func (r *Reconciler) targetsForResource(mt *store.ManifestTarget, ci *v1alpha1.SessionCISpec, result *ctrl.Result) []session.Target {
	var targets []session.Target

	if bt := buildTarget(mt); bt != nil {
		targets = append(targets, *bt)
	}

	if rt := r.runtimeTarget(mt, ci, result); rt != nil {
		targets = append(targets, *rt)
	}

	return targets
}

func (r *Reconciler) localRuntimeTarget(mt *store.ManifestTarget, ci *v1alpha1.SessionCISpec, result *ctrl.Result) *session.Target {
	lrs := mt.State.LocalRuntimeState()
	target := &session.Target{
		Name:      fmt.Sprintf("%s:runtime", mt.Manifest.Name.String()),
		Type:      session.TargetTypeServer,
		Resources: []string{mt.Manifest.Name.String()},
	}

	if lt := mt.Manifest.LocalTarget(); !lt.ServeCmd.Empty() {
		target.Type = session.TargetTypeServer
	} else {
		target.Type = session.TargetTypeJob
	}

	rs := mt.RuntimeStatus()
	target.State.Waiting = waitingFromRuntimeStatus(rs)
	target.State.Active = activeFromRuntimeStatus(rs, lrs.Ready, lrs.StartTime)
	target.State.Terminated = terminatedFromRuntimeStatus(rs)

	return target
}

func waitingFromRuntimeStatus(rs v1alpha1.RuntimeStatus) *session.TargetStateWaiting {
	if rs == v1alpha1.RuntimeStatusPending {
		return &session.TargetStateWaiting{
			WaitReason: "waiting",
		}
	}
	return nil
}

func activeFromRuntimeStatus(rs v1alpha1.RuntimeStatus, ready bool, startTime time.Time) *session.TargetStateActive {
	if rs == v1alpha1.RuntimeStatusOK {
		return &session.TargetStateActive{
			StartTime: apis.NewMicroTime(startTime),
			Ready:     ready,
		}
	}
	if rs == v1alpha1.RuntimeStatusPending && !startTime.IsZero() {
		return &session.TargetStateActive{
			StartTime: apis.NewMicroTime(startTime),
			Ready:     ready,
		}
	}
	return nil
}

func terminatedFromRuntimeStatus(rs v1alpha1.RuntimeStatus) *session.TargetStateTerminated {
	if rs == v1alpha1.RuntimeStatusError {
		return &session.TargetStateTerminated{
			Error: "process exited with error",
		}
	}
	return nil
}

func (r *Reconciler) runtimeTarget(mt *store.ManifestTarget, ci *v1alpha1.SessionCISpec, result *ctrl.Result) *session.Target {
	if mt.Manifest.IsLocal() {
		return r.localRuntimeTarget(mt, ci, result)
	}
	return nil
}

func buildTarget(mt *store.ManifestTarget) *session.Target {
	ms := mt.State
	m := mt.Manifest
	isPending := !ms.PendingManifestChange.IsZero() || ms.HasPendingFileChanges() || ms.HasPendingDependencyChanges()

	if !mt.Manifest.TriggerMode.AutoInitial() && ms.LastBuild().Empty() && len(ms.BuildHistory) == 0 && !isPending && !ms.IsBuilding() {
		return nil
	}

	target := &session.Target{
		Name:      fmt.Sprintf("%s:update", m.Name.String()),
		Resources: []string{m.Name.String()},
		Type:      session.TargetTypeJob,
	}

	if ms.IsBuilding() {
		target.State.Active = &session.TargetStateActive{
			StartTime: apis.NewMicroTime(ms.EarliestCurrentBuild().StartTime),
		}
	} else if isPending {
		pendingReason := pendingBuildReason(mt)
		target.State.Waiting = &session.TargetStateWaiting{
			WaitReason: pendingReason,
		}
	} else {
		lb := ms.LastBuild()
		if lb.Error != nil {
			target.State.Terminated = &session.TargetStateTerminated{
				StartTime:  apis.NewMicroTime(lb.StartTime),
				FinishTime: apis.NewMicroTime(lb.FinishTime),
				Error:      errToString(lb.Error),
			}
		} else if !lb.Empty() {
			target.State.Terminated = &session.TargetStateTerminated{
				StartTime:  apis.NewMicroTime(lb.StartTime),
				FinishTime: apis.NewMicroTime(lb.FinishTime),
			}
		} else {
			target.State.Waiting = &session.TargetStateWaiting{
				WaitReason: "initial",
			}
		}
	}

	return target
}

func pendingBuildReason(mt *store.ManifestTarget) string {
	ms := mt.State
	reasons := []string{}

	if !ms.PendingManifestChange.IsZero() {
		reasons = append(reasons, "config-changed")
	}

	if ms.HasPendingFileChanges() {
		reasons = append(reasons, "file-changed")
	}

	if ms.HasPendingDependencyChanges() {
		reasons = append(reasons, "dependency-changed")
	}

	if len(reasons) > 0 {
		return strings.Join(reasons, ",")
	}

	return "unknown"
}

// errToString returns a stringified version of an error or an empty string if the error is nil.
func errToString(err error) string {
	if err == nil {
		return ""
	}
	return err.Error()
}
