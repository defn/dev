package base

import (
	"github.com/spf13/cobra"
)

// Command interface defines the contract for all commands (root and sub)
type Command interface {
	GetCommand() *cobra.Command
	Main() error
	Register(*cobra.Command) // Optional: only sub-commands use this
}

// BaseCommand provides a default implementation of Command
type BaseCommand struct {
	cmd *cobra.Command
}

func NewCommand(cmd *cobra.Command) *BaseCommand {
	return &BaseCommand{cmd: cmd}
}

func (c *BaseCommand) Register(root_cmd *cobra.Command) {
	root_cmd.AddCommand(c.cmd)
}

func (c *BaseCommand) GetCommand() *cobra.Command {
	return c.cmd
}
