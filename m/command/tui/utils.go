package tui

import (
	"image/color"

	"github.com/charmbracelet/lipgloss"
	"github.com/lucasb-eyer/go-colorful"
)

func rainbow(base_style lipgloss.Style, text string, colors []color.Color) string {
	var result_str string
	for char_idx, char_rune := range text {
		char_color, _ := colorful.MakeColor(colors[char_idx%len(colors)])
		result_str = result_str + base_style.Foreground(lipgloss.Color(char_color.Hex())).Render(string(char_rune))
	}
	return result_str
}
