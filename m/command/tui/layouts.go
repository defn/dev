package tui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/gamut"
)

// layouts
func demoLayout(physical_width int, physical_height int) string {
	w := lipgloss.Width
	h := lipgloss.Height

	var (
		column_width = (physical_width / 3)

		// General style
		subtle_color  = lipgloss.AdaptiveColor{Light: "#D9DCCF", Dark: "#383838"}
		special_color = lipgloss.AdaptiveColor{Light: "#43BF6D", Dark: "#73F59F"}
		blend_colors  = gamut.Blends(lipgloss.Color("#F25D94"), lipgloss.Color("#EDFF82"), 50)

		normal_color = lipgloss.Color("#EEEEEE")
		base_style   = lipgloss.NewStyle().Foreground(normal_color)

		// Dialog.
		dialog_box_style = lipgloss.NewStyle().
					Border(lipgloss.RoundedBorder()).
					BorderForeground(lipgloss.Color("#874BFD")).
					Padding(1, 0).
					BorderTop(true).
					BorderLeft(true).
					BorderRight(true).
					BorderBottom(true)

		button_style = lipgloss.NewStyle().
				Foreground(lipgloss.Color("#FFF7DB")).
				Background(lipgloss.Color("#888B7E")).
				Padding(0, 3).
				MarginTop(1)

		active_button_style = button_style.
					Foreground(lipgloss.Color("#FFF7DB")).
					Background(lipgloss.Color("#F25D94")).
					MarginRight(2).
					Underline(true)

		// List.
		list_style = lipgloss.NewStyle().
				Border(lipgloss.NormalBorder(), false, true, false, false).
				BorderForeground(subtle_color).
				MarginRight(2).
				Height(8).
				Width(column_width + 1)

		list_header_fn = base_style.
				BorderStyle(lipgloss.NormalBorder()).
				BorderBottom(true).
				BorderForeground(subtle_color).
				MarginRight(2).
				Render

		list_item_fn = base_style.PaddingLeft(2).Render

		check_mark_str = lipgloss.NewStyle().SetString("✓").
				Foreground(special_color).
				PaddingRight(1).
				String()

		list_done_fn = func(text string) string {
			return check_mark_str + lipgloss.NewStyle().
				Strikethrough(true).
				Foreground(lipgloss.AdaptiveColor{Light: "#969B86", Dark: "#696969"}).
				Render(text)
		}

		// Status Bar.
		status_nugget_style = lipgloss.NewStyle().
					Foreground(lipgloss.Color("#FFFDF5")).
					Padding(0, 1)

		status_bar_style = lipgloss.NewStyle().
					Foreground(lipgloss.AdaptiveColor{Light: "#343433", Dark: "#C1C6B2"}).
					Background(lipgloss.AdaptiveColor{Light: "#D9DCCF", Dark: "#353533"})

		status_label_style = lipgloss.NewStyle().
					Inherit(status_bar_style).
					Foreground(lipgloss.Color("#FFFDF5")).
					Background(lipgloss.Color("#FF5F87")).
					Padding(0, 1).
					MarginRight(1)

		encoding_style = status_nugget_style.
				Background(lipgloss.Color("#A550DF")).
				Align(lipgloss.Right)

		status_text_style = lipgloss.NewStyle().Inherit(status_bar_style)

		fish_cake_style = status_nugget_style.Background(lipgloss.Color("#6124DF"))
	)

	// Text boxes
	list_columns := lipgloss.JoinHorizontal(lipgloss.Top,
		list_style.Width(column_width).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				list_header_fn("Actual Lip Gloss Vendors"),
				list_done_fn("Glossier"),
				list_done_fn("Claire's Boutique"),
				list_item_fn("Nyx"),
				list_done_fn("Mac"),
				list_item_fn("Milk"),
			),
		),
		list_style.Width(column_width).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				list_header_fn("Citrus Fruits to Try"),
				list_done_fn("Grapefruit"),
				list_done_fn("Yuzu"),
				list_item_fn("Citron"),
				list_item_fn("Kumquat"),
				list_item_fn("Pomelo"),
			),
		),
		list_style.Width(column_width).Render(
			lipgloss.JoinVertical(lipgloss.Left,
				list_header_fn("Actual Lip Gloss Vendors"),
				list_item_fn("Glossier"),
				list_item_fn("Claire's Boutique"),
				list_done_fn("Nyx"),
				list_item_fn("Mac"),
				list_done_fn("Milk"),
			),
		),
	)

	// Status bar
	var status_bar_content string
	{
		status_key := status_label_style.Render("STATUS")
		encoding_label := encoding_style.Render("UTF-8")
		fish_cake_label := fish_cake_style.Render("Fish Cake")

		status_value := status_text_style.
			Width(physical_width - w(status_key) - w(encoding_label) - w(fish_cake_label)).
			Render("Ravishing")

		status_bar_content = lipgloss.JoinHorizontal(lipgloss.Top,
			status_key,
			status_value,
			encoding_label,
			fish_cake_label,
		)
	}

	all_columns := lipgloss.JoinHorizontal(lipgloss.Top, list_columns)
	rendered_status_bar := status_bar_style.Width(physical_width).Render(status_bar_content)

	// Dialog
	var dialog_box string
	{
		question_text := lipgloss.NewStyle().Width(50).Align(lipgloss.Center).Render(rainbow(lipgloss.NewStyle(), "Are you sure you want to eat marmalade?", blend_colors))

		ok_button := active_button_style.Render("Yes")
		maybe_button := button_style.Render("Maybe")

		button_row := lipgloss.JoinHorizontal(lipgloss.Top, ok_button, maybe_button)

		dialog_ui := lipgloss.JoinVertical(lipgloss.Center, question_text, button_row)

		dialog_box = lipgloss.Place(physical_width, physical_height-1-h(all_columns)-h(rendered_status_bar),
			lipgloss.Center, lipgloss.Center,
			dialog_box_style.Render(dialog_ui),
			lipgloss.WithWhitespaceChars(fmt.Sprintf("%d", h(all_columns))),
			lipgloss.WithWhitespaceForeground(subtle_color),
		)
	}
	// lipgloss.WithWhitespaceChars("猫咪"),

	page_doc := strings.Builder{}

	// dialog
	page_doc.WriteString(dialog_box)
	page_doc.WriteString("\n")

	// newline
	page_doc.WriteString("\n")

	// columns
	page_doc.WriteString(all_columns)
	page_doc.WriteString("\n")

	// statusbar
	page_doc.WriteString(rendered_status_bar)

	return page_doc.String()
}
