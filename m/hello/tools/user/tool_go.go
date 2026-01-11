// Package user provides an MCP tool that returns current user information.
package user

import (
	"context"
	"os"
	osuser "os/user"
	"strconv"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// Input is empty as this tool takes no arguments.
type Input struct{}

// Output contains user information.
type Output struct {
	UID       int      `json:"uid"`
	GID       int      `json:"gid"`
	Username  string   `json:"username"`
	Groupname string   `json:"groupname"`
	Home      string   `json:"home"`
	Shell     string   `json:"shell,omitempty"`
	Groups    []string `json:"groups"`
}

// Handler returns current user information.
func Handler(_ context.Context, _ *mcp.CallToolRequest, _ Input) (*mcp.CallToolResult, Output, error) {
	uid := os.Getuid()
	gid := os.Getgid()

	output := Output{
		UID:    uid,
		GID:    gid,
		Groups: []string{},
	}

	// Get user info
	if u, err := osuser.LookupId(strconv.Itoa(uid)); err == nil {
		output.Username = u.Username
		output.Home = u.HomeDir
	} else {
		output.Username = "unknown"
		output.Home = os.Getenv("HOME")
	}

	// Get group info
	if g, err := osuser.LookupGroupId(strconv.Itoa(gid)); err == nil {
		output.Groupname = g.Name
	} else {
		output.Groupname = "unknown"
	}

	// Get shell from environment or passwd
	if shell := os.Getenv("SHELL"); shell != "" {
		output.Shell = shell
	}

	// Get supplementary groups
	if gids, err := os.Getgroups(); err == nil {
		for _, gid := range gids {
			if g, err := osuser.LookupGroupId(strconv.Itoa(gid)); err == nil {
				output.Groups = append(output.Groups, g.Name)
			} else {
				output.Groups = append(output.Groups, strconv.Itoa(gid))
			}
		}
	}

	// Remove duplicates and sort
	output.Groups = unique(output.Groups)

	return nil, output, nil
}

func unique(slice []string) []string {
	seen := make(map[string]bool)
	result := []string{}
	for _, s := range slice {
		if !seen[s] {
			seen[s] = true
			result = append(result, s)
		}
	}
	return result
}

// Tool returns the MCP tool definition.
func Tool() *mcp.Tool {
	return &mcp.Tool{
		Name:        "get_user_info",
		Description: "Get current user and group information as JSON",
	}
}
