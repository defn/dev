package command

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"

	tea "github.com/charmbracelet/bubbletea"

	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/lipgloss"

	root "github.com/defn/dev/m/command/root"
)

var physicalWidth int
var physicalHeight int

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "tui",
		Short: "A brief description of your command",
		Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
		Run: func(cmd *cobra.Command, args []string) {
			// items
			items := []list.Item{
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
			listHeight := 20
			l := list.New(items, itemDelegate{}, physicalWidth, listHeight)
			l.Title = "What do you want for dinner?"
			l.SetShowStatusBar(false)
			l.SetFilteringEnabled(false)
			l.Styles.Title = lipgloss.NewStyle().MarginLeft(2)
			l.Styles.PaginationStyle = list.DefaultStyles().PaginationStyle.PaddingLeft(4)
			l.Styles.HelpStyle = list.DefaultStyles().HelpStyle.PaddingLeft(4).PaddingBottom(1)

			// model
			m := order{menu: l}

			// run program
			if _, err := tea.NewProgram(m).Run(); err != nil {
				fmt.Println("Error running program:", err)
				os.Exit(1)
			}
		},
	})
}
