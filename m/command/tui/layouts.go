package command

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/gamut"
)

// layouts
func demoLayout() string {
	w := lipgloss.Width

	var (
		columnWidth = (physicalWidth / 3)

		// General style
		normal  = lipgloss.Color("#EEEEEE")
		subtle  = lipgloss.AdaptiveColor{Light: "#D9DCCF", Dark: "#383838"}
		special = lipgloss.AdaptiveColor{Light: "#43BF6D", Dark: "#73F59F"}
		blends  = gamut.Blends(lipgloss.Color("#F25D94"), lipgloss.Color("#EDFF82"), 50)

		base = lipgloss.NewStyle().Foreground(normal)

		// Dialog.
		dialogBoxStyle = lipgloss.NewStyle().
				Border(lipgloss.RoundedBorder()).
				BorderForeground(lipgloss.Color("#874BFD")).
				Padding(1, 0).
				BorderTop(true).
				BorderLeft(true).
				BorderRight(true).
				BorderBottom(true)

		buttonStyle = lipgloss.NewStyle().
				Foreground(lipgloss.Color("#FFF7DB")).
				Background(lipgloss.Color("#888B7E")).
				Padding(0, 3).
				MarginTop(1)

		activeButtonStyle = buttonStyle.
					Foreground(lipgloss.Color("#FFF7DB")).
					Background(lipgloss.Color("#F25D94")).
					MarginRight(2).
					Underline(true)

		// List.
		list2 = lipgloss.NewStyle().
			Border(lipgloss.NormalBorder(), false, true, false, false).
			BorderForeground(subtle).
			MarginRight(2).
			Height(8).
			Width(columnWidth + 1)

		listHeader = base.
				BorderStyle(lipgloss.NormalBorder()).
				BorderBottom(true).
				BorderForeground(subtle).
				MarginRight(2).
				Render

		listItem = base.PaddingLeft(2).Render

		checkMark = lipgloss.NewStyle().SetString("✓").
				Foreground(special).
				PaddingRight(1).
				String()

		listDone = func(s string) string {
			return checkMark + lipgloss.NewStyle().
				Strikethrough(true).
				Foreground(lipgloss.AdaptiveColor{Light: "#969B86", Dark: "#696969"}).
				Render(s)
		}

		// Status Bar.
		statusNugget = lipgloss.NewStyle().
				Foreground(lipgloss.Color("#FFFDF5")).
				Padding(0, 1)

		statusBarStyle = lipgloss.NewStyle().
				Foreground(lipgloss.AdaptiveColor{Light: "#343433", Dark: "#C1C6B2"}).
				Background(lipgloss.AdaptiveColor{Light: "#D9DCCF", Dark: "#353533"})

		statusStyle = lipgloss.NewStyle().
				Inherit(statusBarStyle).
				Foreground(lipgloss.Color("#FFFDF5")).
				Background(lipgloss.Color("#FF5F87")).
				Padding(0, 1).
				MarginRight(1)

		encodingStyle = statusNugget.
				Background(lipgloss.Color("#A550DF")).
				Align(lipgloss.Right)

		statusText = lipgloss.NewStyle().Inherit(statusBarStyle)

		fishCakeStyle = statusNugget.Background(lipgloss.Color("#6124DF"))
	)

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

	// Status bar
	var bar string
	{
		statusKey := statusStyle.Render("STATUS")
		encoding := encodingStyle.Render("UTF-8")
		fishCake := fishCakeStyle.Render("Fish Cake")

		statusVal := statusText.
			Width(physicalWidth - w(statusKey) - w(encoding) - w(fishCake)).
			Render("Ravishing")

		bar = lipgloss.JoinHorizontal(lipgloss.Top,
			statusKey,
			statusVal,
			encoding,
			fishCake,
		)
	}

	cols := lipgloss.JoinHorizontal(lipgloss.Top, lists)
	sbar := statusBarStyle.Width(physicalWidth).Render(bar)

	// Dialog
	var dialog string
	{
		question := lipgloss.NewStyle().Width(50).Align(lipgloss.Center).Render(rainbow(lipgloss.NewStyle(), "Are you sure you want to eat marmalade?", blends))

		okButton := activeButtonStyle.Render("Yes")
		maybeButton := buttonStyle.Render("Maybe")

		buttons := lipgloss.JoinHorizontal(lipgloss.Top, okButton, maybeButton)

		ui := lipgloss.JoinVertical(lipgloss.Center, question, buttons)

		// TODO how to calculate 10 from cols and sbar?
		dialog = lipgloss.Place(physicalWidth, physicalHeight-10,
			lipgloss.Center, lipgloss.Center,
			dialogBoxStyle.Render(ui),
			lipgloss.WithWhitespaceChars("猫咪"),
			lipgloss.WithWhitespaceForeground(subtle),
		)
	}

	doc := strings.Builder{}

	doc.WriteString(dialog)
	doc.WriteString("\n")
	doc.WriteString("\n")
	doc.WriteString(cols)
	doc.WriteString("\n")
	doc.WriteString(sbar)

	return doc.String()
}
