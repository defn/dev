package base

import (
	"github.com/spf13/cobra"
)

// RootCommand interface defines the contract for root commands
type RootCommand interface {
	GetCommand() *cobra.Command
}

// BaseRootCommand provides a default implementation of RootCommand
type BaseRootCommand struct {
	cmd *cobra.Command
}

func NewRootCommand(cmd *cobra.Command) *BaseRootCommand {
	return &BaseRootCommand{cmd: cmd}
}

func (r *BaseRootCommand) GetCommand() *cobra.Command {
	return r.cmd
}

// SubCommand interface defines the contract for all sub-commands
type SubCommand interface {
	Register(*cobra.Command)
	GetCommand() *cobra.Command
}

// BaseSubCommand provides a default implementation of SubCommand
type BaseSubCommand struct {
	cmd *cobra.Command
}

func NewSubCommand(cmd *cobra.Command) *BaseSubCommand {
	return &BaseSubCommand{cmd: cmd}
}

func (b *BaseSubCommand) Register(root_cmd *cobra.Command) {
	root_cmd.AddCommand(b.cmd)
}

func (b *BaseSubCommand) GetCommand() *cobra.Command {
	return b.cmd
}
