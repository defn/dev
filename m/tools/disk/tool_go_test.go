package disk

import (
	"context"
	"testing"

	"golang.org/x/sys/unix"
)

func TestHandler_ReturnsOutput(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.TotalBytes == 0 {
		t.Error("expected total_bytes to be non-zero")
	}
	if output.FreeBytes == 0 {
		t.Error("expected free_bytes to be non-zero")
	}
	if output.PercentUsed == 0 {
		t.Error("expected percent_used to be non-zero")
	}
}

func TestHandler_DefaultPath(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.Path != "/" {
		t.Errorf("expected path '/', got '%s'", output.Path)
	}
}

func TestHandler_CustomPath(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{Path: "/tmp"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if output.Path != "/tmp" {
		t.Errorf("expected path '/tmp', got '%s'", output.Path)
	}
}

func TestHandler_MatchesStatfs(t *testing.T) {
	_, output, err := Handler(context.Background(), nil, Input{Path: "/"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	var stat unix.Statfs_t
	if err := unix.Statfs("/", &stat); err != nil {
		t.Fatalf("statfs failed: %v", err)
	}

	expectedTotal := stat.Blocks * uint64(stat.Bsize)
	if output.TotalBytes != expectedTotal {
		t.Errorf("expected total_bytes %d, got %d", expectedTotal, output.TotalBytes)
	}
}

func TestHandler_InvalidPath(t *testing.T) {
	result, _, err := Handler(context.Background(), nil, Input{Path: "/nonexistent/path/12345"})
	if err == nil {
		t.Error("expected error for invalid path")
	}
	if result == nil || !result.IsError {
		t.Error("expected IsError to be true")
	}
}

func TestTool_ReturnsDefinition(t *testing.T) {
	tool := Tool()
	if tool.Name != "get_disk_usage" {
		t.Errorf("expected name 'get_disk_usage', got '%s'", tool.Name)
	}
	if tool.Description == "" {
		t.Error("expected non-empty description")
	}
}
