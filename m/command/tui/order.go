package tui

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"

	"github.com/charmbracelet/bubbles/list"
)

// type order
type order struct {
	menu            list.Model
	choice          string
	quitting        bool
	physical_width  int
	physical_height int
}

func (m order) Init() tea.Cmd {
	return nil
}

func (m order) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch typed_msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.menu.SetWidth(typed_msg.Width)
		m.physical_width = typed_msg.Width
		m.physical_height = typed_msg.Height
		return m, nil

	case tea.KeyMsg:
		switch key_press := typed_msg.String(); key_press {
		case "ctrl+c":
			m.quitting = true
			return m, tea.Quit

		case "q":
			m.quitting = !m.quitting
			return m, nil

		case "enter":
			selected_item, ok := m.menu.SelectedItem().(item)
			if ok {
				m.choice = string(selected_item)
			}
			return m, tea.Quit
		}
	}

	var tea_cmd tea.Cmd
	m.menu, tea_cmd = m.menu.Update(msg)
	return m, tea_cmd
}

func (m order) View() string {
	if m.choice != "" {
		quit_text_style := lipgloss.NewStyle().Margin(1, 0, 2, 4)
		return quit_text_style.Render(fmt.Sprintf("%s? Sounds good to me.", m.choice))
	}

	if m.quitting {
		doc_style := lipgloss.NewStyle().Padding(0, 0, 0, 0).MaxWidth(m.physical_width)
		return doc_style.Render(demoLayout(m.physical_width, m.physical_height))
	}

	return m.menu.View()
}
