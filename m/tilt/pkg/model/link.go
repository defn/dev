package model

// Link represents a URL link associated with a resource.
type Link struct {
	URL  string
	Name string
}

// LinksToURLStrings converts a slice of Links to a slice of URL strings.
func LinksToURLStrings(links []Link) []string {
	result := make([]string, len(links))
	for i, l := range links {
		result[i] = l.URL
	}
	return result
}

// ByURL implements sort.Interface for []Link based on URL.
type ByURL []Link

func (a ByURL) Len() int           { return len(a) }
func (a ByURL) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a ByURL) Less(i, j int) bool { return a[i].URL < a[j].URL }
