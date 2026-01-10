package time

import (
	"context"
	"testing"
	"time"
)

func TestHandler_ReturnsOutput(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.UTC == "" {
		t.Error("expected utc to be non-empty")
	}
	if output.Local == "" {
		t.Error("expected local to be non-empty")
	}
	if output.Timestamp == 0 {
		t.Error("expected timestamp to be non-zero")
	}
}

func TestHandler_TimeIsRecent(t *testing.T) {
	before := float64(time.Now().UTC().UnixNano()) / 1e9
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	after := float64(time.Now().UTC().UnixNano()) / 1e9

	if output.Timestamp < before {
		t.Errorf("timestamp %f is before test start %f", output.Timestamp, before)
	}
	if output.Timestamp > after {
		t.Errorf("timestamp %f is after test end %f", output.Timestamp, after)
	}
}

func TestHandler_UTCFormat(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Verify UTC can be parsed as RFC3339Nano
	_, err = time.Parse(time.RFC3339Nano, output.UTC)
	if err != nil {
		t.Errorf("UTC time not in RFC3339Nano format: %v", err)
	}
}

func TestTool_ReturnsDefinition(t *testing.T) {
	tool := Tool()
	if tool.Name != "get_time" {
		t.Errorf("expected name 'get_time', got '%s'", tool.Name)
	}
	if tool.Description == "" {
		t.Error("expected non-empty description")
	}
}
