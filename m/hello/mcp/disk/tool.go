// Package disk provides an MCP tool that returns disk usage information.
package disk

import (
	"context"
	"math"

	"github.com/modelcontextprotocol/go-sdk/mcp"
	"golang.org/x/sys/unix"
)

// Input contains the path to check.
type Input struct {
	Path string `json:"path,omitempty" jsonschema:"Path to check disk usage for"`
}

// Output contains disk usage statistics.
type Output struct {
	Path        string  `json:"path"`
	TotalBytes  uint64  `json:"total_bytes"`
	UsedBytes   uint64  `json:"used_bytes"`
	FreeBytes   uint64  `json:"free_bytes"`
	PercentUsed float64 `json:"percent_used"`
}

// Handler returns disk usage for the specified path.
func Handler(_ context.Context, _ *mcp.CallToolRequest, input Input) (*mcp.CallToolResult, Output, error) {
	path := input.Path
	if path == "" {
		path = "/"
	}

	var stat unix.Statfs_t
	if err := unix.Statfs(path, &stat); err != nil {
		return &mcp.CallToolResult{IsError: true}, Output{}, err
	}

	total := stat.Blocks * uint64(stat.Bsize)
	free := stat.Bfree * uint64(stat.Bsize)
	used := total - free
	percentUsed := math.Round(float64(used)/float64(total)*1000) / 10

	return nil, Output{
		Path:        path,
		TotalBytes:  total,
		UsedBytes:   used,
		FreeBytes:   free,
		PercentUsed: percentUsed,
	}, nil
}

// Tool returns the MCP tool definition.
func Tool() *mcp.Tool {
	return &mcp.Tool{
		Name:        "get_disk_usage",
		Description: "Get disk usage statistics as JSON for a given path (default: root filesystem)",
	}
}
