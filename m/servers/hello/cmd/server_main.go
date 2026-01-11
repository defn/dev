// MCP server providing time, disk, and user information tools.
//
// This server can be run standalone and used by any MCP-compatible client
// like Claude CLI or other agent frameworks.
//
// Usage:
//
//	bazel run //servers/hello:server_go
package main

import (
	"context"
	"log"
	"os"

	"github.com/modelcontextprotocol/go-sdk/mcp"

	mcpserver "github.com/defn/dev/m/servers/hello"
)

func main() {
	server := mcpserver.NewServer()

	if err := server.Run(context.Background(), &mcp.StdioTransport{}); err != nil {
		log.Printf("Server error: %v", err)
		os.Exit(1)
	}
}
