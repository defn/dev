package command

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"

	"github.com/charmbracelet/bubbles/list"
)

// type order
type order struct {
	menu     list.Model
	choice   string
	quitting bool
}

func (m order) Init() tea.Cmd {
	return nil
}

func (m order) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.menu.SetWidth(msg.Width)
		physicalWidth = msg.Width
		physicalHeight = msg.Height
		return m, nil

	case tea.KeyMsg:
		switch keypress := msg.String(); keypress {
		case "ctrl+c", "q":
			m.quitting = true
			return m, nil

		case "enter":
			i, ok := m.menu.SelectedItem().(item)
			if ok {
				m.choice = string(i)
			}
			return m, tea.Quit
		}
	}

	var cmd tea.Cmd
	m.menu, cmd = m.menu.Update(msg)
	return m, cmd
}

func (m order) View() string {
	if m.choice != "" {
		quitTextStyle := lipgloss.NewStyle().Margin(1, 0, 2, 4)
		return quitTextStyle.Render(fmt.Sprintf("%s? Sounds good to me.", m.choice))
	}

	if m.quitting {
		docStyle := lipgloss.NewStyle().Padding(1, 0, 1, 0).MaxWidth(physicalWidth)
		return docStyle.Render(demoLayout())
	}

	return m.menu.View()
}
