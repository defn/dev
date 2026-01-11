package user

import (
	"context"
	"os"
	"testing"
)

func TestHandler_ReturnsOutput(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.Username == "" {
		t.Error("expected username to be non-empty")
	}
	if output.Groupname == "" {
		t.Error("expected groupname to be non-empty")
	}
	if output.Home == "" {
		t.Error("expected home to be non-empty")
	}
}

func TestHandler_MatchesOS(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.UID != os.Getuid() {
		t.Errorf("expected uid %d, got %d", os.Getuid(), output.UID)
	}
	if output.GID != os.Getgid() {
		t.Errorf("expected gid %d, got %d", os.Getgid(), output.GID)
	}
}

func TestHandler_HasGroups(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.Groups == nil {
		t.Error("expected groups to be non-nil")
	}
}

func TestTool_ReturnsDefinition(t *testing.T) {
	tool := Tool()
	if tool.Name != "get_user_info" {
		t.Errorf("expected name 'get_user_info', got '%s'", tool.Name)
	}
	if tool.Description == "" {
		t.Error("expected non-empty description")
	}
}
