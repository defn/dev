package command

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

// layouts
func demoLayout() string {
	doc := strings.Builder{}

	// Tabs
	{
		row := lipgloss.JoinHorizontal(
			lipgloss.Top,
			tab.Render("Blush"),
			activeTab.Render("Lip Gloss"),
			tab.Render("Eye Shadow"),
			tab.Render("Mascara"),
			tab.Render("Foundation"),
		)
		gap := tabGap.Render(strings.Repeat(" ", max(0, physicalWidth-lipgloss.Width(row)-2)))
		row = lipgloss.JoinHorizontal(lipgloss.Bottom, row, gap)
		doc.WriteString(row + "\n\n")
	}

	// Title
	{
		var colors = colorGrid(1, 5)
		var title strings.Builder
		for i, v := range colors {
			const offset = 2
			c := lipgloss.Color(v[0])
			fmt.Fprint(&title, titleStyle.MarginLeft(i*offset).Background(c))
			if i < len(colors)-1 {
				title.WriteRune('\n')
			}
		}

		desc := lipgloss.JoinVertical(lipgloss.Left,
			descStyle.Render("Style Definitions for Nice Terminal Layouts"),
			infoStyle.Render("From Charm"+divider+url("https://github.com/charmbracelet/lipgloss")),
		)

		row := lipgloss.JoinHorizontal(lipgloss.Top, title.String(), desc)

		doc.WriteString(row)
		doc.WriteString("\n\n")
	}

	// Dialog
	{
		question := lipgloss.NewStyle().Width(50).Align(lipgloss.Center).Render(rainbow(lipgloss.NewStyle(), "Are you sure you want to eat marmalade?", blends))

		okButton := activeButtonStyle.Render("Yes")
		cancelButton := buttonStyle.Render("Maybe")
		buttons := lipgloss.JoinHorizontal(lipgloss.Top, okButton, cancelButton)

		ui := lipgloss.JoinVertical(lipgloss.Center, question, buttons)

		dialog := lipgloss.Place(physicalWidth, 9,
			lipgloss.Center, lipgloss.Center,
			dialogBoxStyle.Render(ui),
			lipgloss.WithWhitespaceChars("猫咪"),
			lipgloss.WithWhitespaceForeground(subtle),
		)

		doc.WriteString(dialog)
		doc.WriteString("\n\n")
	}

	// Text boxes
	lists := lipgloss.JoinHorizontal(lipgloss.Top,
		list2.Width(columnWidth).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				listHeader("Actual Lip Gloss Vendors"),
				listDone("Glossier"),
				listDone("Claire‘s Boutique"),
				listItem("Nyx"),
				listDone("Mac"),
				listItem("Milk"),
			),
		),
		list2.Width(columnWidth).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				listHeader("Citrus Fruits to Try"),
				listDone("Grapefruit"),
				listDone("Yuzu"),
				listItem("Citron"),
				listItem("Kumquat"),
				listItem("Pomelo"),
			),
		),
		list2.Width(columnWidth).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				listHeader("Actual Lip Gloss Vendors"),
				listItem("Glossier"),
				listItem("Claire‘s Boutique"),
				listDone("Nyx"),
				listItem("Mac"),
				listDone("Milk"),
			),
		),
	)

	doc.WriteString(lipgloss.JoinHorizontal(lipgloss.Top, lists))
	doc.WriteString("\n")

	// Status bar
	{
		w := lipgloss.Width

		statusKey := statusStyle.Render("STATUS")
		encoding := encodingStyle.Render("UTF-8")
		fishCake := fishCakeStyle.Render("Fish Cake")

		statusVal := statusText.
			Width(physicalWidth - w(statusKey) - w(encoding) - w(fishCake)).
			Render("Ravishing")

		bar := lipgloss.JoinHorizontal(lipgloss.Top,
			statusKey,
			statusVal,
			encoding,
			fishCake,
		)

		doc.WriteString(statusBarStyle.Width(physicalWidth).Render(bar))
	}

	// crop to physical width
	if physicalWidth > 0 {
		docStyle = docStyle.MaxWidth(physicalWidth)
	}

	// return the rendered document
	return doc.String()
}
