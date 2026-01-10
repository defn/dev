// Package mcp provides an MCP server with time, disk, and user tools.
package mcp

import (
	"github.com/modelcontextprotocol/go-sdk/mcp"

	"github.com/defn/dev/m/hello/tools/disk"
	toolstime "github.com/defn/dev/m/hello/tools/time"
	"github.com/defn/dev/m/hello/tools/user"
)

// NewServer creates an MCP server with all hello tools.
func NewServer() *mcp.Server {
	server := mcp.NewServer(&mcp.Implementation{
		Name:    "hello_tools",
		Version: "1.0.0",
	}, nil)

	// Add time tool
	mcp.AddTool(server, toolstime.Tool(), toolstime.Handler)

	// Add disk tool
	mcp.AddTool(server, disk.Tool(), disk.Handler)

	// Add user tool
	mcp.AddTool(server, user.Tool(), user.Handler)

	return server
}
