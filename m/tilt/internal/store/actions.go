package store

import (
	"fmt"
	"time"

	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/defn/dev/m/tilt/pkg/model/logstore"
)

type ErrorAction struct {
	Error error
}

func (ErrorAction) Action() {}

func NewErrorAction(err error) ErrorAction {
	return ErrorAction{Error: err}
}

type LogAction struct {
	mn        model.ManifestName
	spanID    logstore.SpanID
	timestamp time.Time
	fields    logger.Fields
	msg       []byte
	level     logger.Level
}

func (LogAction) Action() {}

func (LogAction) Summarize(s *ChangeSummary) {
	s.Log = true
}

func (le LogAction) ManifestName() model.ManifestName {
	return le.mn
}

func (le LogAction) Level() logger.Level {
	return le.level
}

func (le LogAction) Time() time.Time {
	return le.timestamp
}

func (le LogAction) Fields() logger.Fields {
	return le.fields
}

func (le LogAction) Message() []byte {
	return le.msg
}

func (le LogAction) SpanID() logstore.SpanID {
	return le.spanID
}

func (le LogAction) String() string {
	return fmt.Sprintf("manifest: %s, spanID: %s, msg: %q", le.mn, le.spanID, le.msg)
}

func NewLogAction(mn model.ManifestName, spanID logstore.SpanID, level logger.Level, fields logger.Fields, b []byte) LogAction {
	return LogAction{
		mn:        mn,
		spanID:    spanID,
		level:     level,
		timestamp: time.Now(),
		msg:       append([]byte{}, b...),
		fields:    fields,
	}
}

func NewGlobalLogAction(level logger.Level, b []byte) LogAction {
	return LogAction{
		mn:        "",
		spanID:    "",
		level:     level,
		timestamp: time.Now(),
		msg:       append([]byte{}, b...),
	}
}

type TiltCloudStatusReceivedAction struct {
	SuggestedTiltVersion string
}

func (TiltCloudStatusReceivedAction) Action() {}

type PanicAction struct {
	Err error
}

func (PanicAction) Action() {}

type AppendToTriggerQueueAction struct {
	Name   model.ManifestName
	Reason model.BuildReason
}

func (AppendToTriggerQueueAction) Action() {}
