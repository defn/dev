package l

import (
	"strings"
)

html: #HTML

#HTML: """
<!doctype html>
<html>
\(#Head)
\(#Body)
</html>
"""

#Head: """
<head>
	<script src="https://cdn.tailwindcss.com"></script>
	<script src="https://unpkg.com/@phosphor-icons/web"></script>

	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/concourse_2_caps.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/concourse_3.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/valkyrie_a.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/hermes_maia_4.css" />

	<style>
		body {
			font-family: valkyrie_a;
		}
	</style>
</head>
"""

#Body: """
<body class="bg-white px-6 lg:px-8">
\(#Page.html)
</body >
"""

#Page: {
	content: string
	html:    """
<div class="mx-auto max-w-3xl text-base text-gray-700">
\(#Content)
</div>
"""
}

#Title: {
	title:   string
	content: string
	html:    """
		<h1 class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">\(title)</h1>
		<p class="mt-6 text-xl leading-8">\(content)</p>
		"""
}

#Section: {
	title:   string
	content: string
	html:    """
		<div class="mt-10 max-w-2xl">
			<h2 class="text-2xl font-bold tracking-tight text-gray-900">\(title)</h2>
			\(content)
		</div>
		"""
}

#List: {
	items: [...{
		title:   string
		content: string
	}]
	items_content: [
		for ele in items {"""
			<li class="flex gap-x-3">
				<svg class="mt-1 h-5 w-5 flex-none text-indigo-600" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
					<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
				</svg>
				<span><strong class="font-semibold text-gray-900">\(ele.title)</strong> \(ele.content)</span>
			</li>
			"""
		},
	]
	html: """
		<ul role="list" class="mt-8 max-w-xl space-y-8 text-gray-600">\(strings.Join(items_content, ""))</ul>
		"""
}

#Tutorial: {
	title: string
	steps: #List.items
	html:  (#Section & {
		"title": title
		content: (#List & {items: steps}).html
	}).html
}
