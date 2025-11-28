package tui

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"go.uber.org/fx"

	tea "github.com/charmbracelet/bubbletea"

	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/lipgloss"

	"github.com/defn/dev/m/cmd/base"
)

var Module = fx.Module("SubCommandTui",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`group:"subs"`),
		),
	),
)

type subCommand struct {
	*base.BaseCommand
}

func NewCommand() base.Command {
	sub := &subCommand{}

	cmd := &cobra.Command{
		Use:   "tui",
		Short: "Demo of charmbracelet TUI",
		Long:  `Demo of charmbracelet TUI`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			if err := sub.Main(); err != nil {
				fmt.Printf("Error: %v\n", err)
				os.Exit(1)
			}
		},
	}

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *subCommand) Main() error {
	// items
	menu_items := []list.Item{
		item("Ramen"),
		item("Tomato Soup"),
		item("Hamburgers"),
		item("Cheeseburgers"),
		item("Currywurst"),
		item("Okonomiyaki"),
		item("Pasta"),
		item("Fillet Mignon"),
		item("Caviar"),
		item("Just Wine"),
	}

	// list widget
	list_height := 20
	menu_list := list.New(menu_items, itemDelegate{}, 0, list_height)
	menu_list.Title = "What do you want for dinner?"
	menu_list.SetShowStatusBar(false)
	menu_list.SetFilteringEnabled(false)
	menu_list.Styles.Title = lipgloss.NewStyle().MarginLeft(2)
	menu_list.Styles.PaginationStyle = list.DefaultStyles().PaginationStyle.PaddingLeft(4)
	menu_list.Styles.HelpStyle = list.DefaultStyles().HelpStyle.PaddingLeft(4).PaddingBottom(1)

	// model
	model := order{menu: menu_list}

	// run program
	_, err := tea.NewProgram(model).Run()
	return err
}
