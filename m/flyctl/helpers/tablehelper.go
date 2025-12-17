package helpers

import (
	"io"

	tablewriter "github.com/olekukonko/tablewriter"
)

func MakeSimpleTable(out io.Writer, headings []string) (table *tablewriter.Table) {
	newtable := tablewriter.NewWriter(out)
	newtable.SetHeader(headings)
	newtable.SetHeaderLine(true)
	newtable.SetBorder(false)
	newtable.SetAutoFormatHeaders(true)
	newtable.SetHeaderAlignment(tablewriter.ALIGN_LEFT)
	newtable.SetAlignment(tablewriter.ALIGN_LEFT)
	newtable.SetTablePadding(" ")
	newtable.SetCenterSeparator("*")
	newtable.SetRowSeparator("-")
	newtable.SetAutoWrapText(false)
	return newtable
}
