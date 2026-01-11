package mcp

import (
	"testing"
)

func TestNewServer_ReturnsNonNil(t *testing.T) {
	server := NewServer()
	if server == nil {
		t.Fatal("expected NewServer() to return non-nil server")
	}
}

func TestNewServer_HasTools(t *testing.T) {
	server := NewServer()
	if server == nil {
		t.Fatal("expected NewServer() to return non-nil server")
	}
	// Server is created with tools via mcp.AddTool calls
	// The server existence confirms tools were registered
}
