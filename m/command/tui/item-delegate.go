package command

import (
	"fmt"
	"io"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"

	"github.com/charmbracelet/bubbles/list"
)

var (
	item_style          = lipgloss.NewStyle().PaddingLeft(4)
	selected_item_style = lipgloss.NewStyle().PaddingLeft(2).Foreground(lipgloss.Color("170"))
)

// type itemDelegate
type itemDelegate struct{}

func (d itemDelegate) Height() int {
	return 1
}

func (d itemDelegate) Spacing() int {
	return 0
}

func (d itemDelegate) Update(msg tea.Msg, m *list.Model) tea.Cmd {
	return nil
}

func (d itemDelegate) Render(w io.Writer, m list.Model, index int, list_item list.Item) {
	menu_item, ok := list_item.(item)
	if !ok {
		return
	}

	item_str := fmt.Sprintf("%d. %s", index+1, menu_item)

	render_fn := item_style.Render
	if index == m.Index() {
		render_fn = func(s ...string) string {
			return selected_item_style.Render("> " + s[0])
		}
	}

	fmt.Fprint(w, render_fn(item_str))
}
