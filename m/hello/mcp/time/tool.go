// Package time provides an MCP tool that returns the current time.
package time

import (
	"context"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// Input is empty as this tool takes no arguments.
type Input struct{}

// Output contains the time information as JSON.
type Output struct {
	UTC       string  `json:"utc"`
	Local     string  `json:"local"`
	Timestamp float64 `json:"timestamp"`
}

// Handler returns the current time.
func Handler(_ context.Context, _ *mcp.CallToolRequest, _ Input) (*mcp.CallToolResult, Output, error) {
	now := time.Now()
	utc := now.UTC()

	return nil, Output{
		UTC:       utc.Format(time.RFC3339Nano),
		Local:     now.Format(time.RFC3339Nano),
		Timestamp: float64(utc.UnixNano()) / 1e9,
	}, nil
}

// Tool returns the MCP tool definition.
func Tool() *mcp.Tool {
	return &mcp.Tool{
		Name:        "get_time",
		Description: "Get the current date and time as JSON",
	}
}
