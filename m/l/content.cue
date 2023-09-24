package l

import (
	"strings"
)

// Content decorates content
#Content: {
	...
	content: {
		...
		html: string
	}
	html: string | *content.html
}

// PageContent decorates a page
#PageContent: #Content & {
	content: html: string
	html: content.html
}

// TitleContent decorates a title
#TitleContent: #Content & {
	title: string
	desc:  string | *""
	html:  """
		<h1 class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">\(title)</h1>
		<p class="mt-6 text-xl leading-8">\(desc)</p>
		"""
}

// SectionContent decorates a section
#SectionContent: #Content & {
	title: string
	content: html: string
	html: """
		<div class="mt-10 max-w-2xl">
			<h2 class="text-2xl font-bold tracking-tight text-gray-900">\(title)</h2>
			\(content.html)
		</div>
		"""
}

// ListContent decorates a list
#ListContent: #Content & {
	items: [...{
		title: string
		desc:  string | *""
	}]
	content: {
		items_html: [
			for ele in items {"""
				<li class="flex gap-x-3">
					<svg class="mt-1 h-5 w-5 flex-none text-indigo-600" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
						<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
					</svg>
					<span>
						<strong class="font-semibold text-gray-900">\(ele.title)</strong>
						<br>
						\(ele.desc)
					</span>
				</li>
				"""
			},
		]
		html: strings.Join(items_html, "")
	}
	html: """
		<div class="mx-auto max-w-3xl text-base text-gray-700">
		<ul role="list" class="mt-8 max-w-xl space-y-8 text-gray-600">\(content.html)</ul>
		<br>
		<br>
		</div>
		"""
}

// TutorialContent decores a Tutorial Section
#TutorialContent: #Content & {
	title:   string
	steps:   #ListContent.items
	content: #SectionContent & {
		"title": title
		content: (#ListContent & {items: steps})
	}
}
