package m

#HTML: {
	"""
    <!doctype html>
    <html>
        \(#Head)
        \(#Body)
    </html>
    """
}

#Head: {
	"""
		<head>
		    <script src="https://cdn.tailwindcss.com"></script>
		</head>
		"""
}

#Body: {
	"""
    <body class="bg-white">
        <ul role="list" class="divide-y divide-gray-100">
            \((#Person & {input: {
		name:      "Leslie Alexander"
		email:     "leslie.alexander@example.com"
		last_seen: "3h ago"
		title:     "Co-Founder / CEO"
		profile:   "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)

            \((#Person & {input: {
		name:      "Michael Foster"
		email:     "michael.foster@example.com"
		last_seen: "3h ago"
		title:     "Co-Founder / CTO"
		profile:   "https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)

            \((#Person & {input: {
		name:      "Dries Vincent"
		email:     "dries.vincent@example.com"
		last_seen: "Online"
		title:     "Business Relations"
		profile:   "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)

            \((#Person & {input: {
		name:      "Lindsay Walton"
		email:     "lindsay.walton@example.com"
		last_seen: "3h ago"
		title:     "Front-end Developer"
		profile:   "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)

            \((#Person & {input: {
		name:      "Courtney Henry"
		email:     "courtney.henry@example.com"
		last_seen: "3h ago"
		title:     "Designer"
		profile:   "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)

            \((#Person & {input: {
		name:      "Tom Cook"
		email:     "tom.cook@example.com"
		last_seen: "Online"
		title:     "Director of Product"
		profile:   "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
	}}).html)
        </ul>
    </body>
    """
}

#Input: {
	profile:   string
	name:      string
	email:     string
	title:     string
	last_seen: string
}

#Person: {
	input: #Input
	html:  """
    <li class="flex justify-between gap-x-6 py-5">
    <div class="flex min-w-0 gap-x-4">
        <img
        class="h-12 w-12 flex-none rounded-full bg-gray-50"
        src="\(input.profile)"
        alt=""
        />
        <div class="min-w-0 flex-auto">
        <p class="text-sm font-semibold leading-6 text-gray-900">
            \(input.name)
        </p>
        <p class="mt-1 truncate text-xs leading-5 text-gray-500">
            \(input.email)
        </p>
        </div>
    </div>
    <div class="hidden shrink-0 sm:flex sm:flex-col sm:items-end">
        <p class="text-sm leading-6 text-gray-900">\(input.title)</p>
        \((#Online & {"input": input}).html)
    </div>
    </li>
    """
}

#Online: {
	input: #Input

	html: {
		if input.last_seen == "Online" {
			"""
			<div class="mt-1 flex items-center gap-x-1.5">
                <div class="flex-none rounded-full bg-emerald-500/20 p-1">
                    <div class="h-1.5 w-1.5 rounded-full bg-emerald-500"></div>
                </div>
                <p class="text-xs leading-5 text-gray-500">Online</p>
            </div>
            """
		}

		if input.last_seen != "Online" {
			"""
            <p class="mt-1 text-xs leading-5 text-gray-500">
                Last seen <time datetime="2023-01-23T13:23Z">\(input.last_seen)</time>
            </p>
            """
		}
	}
}

html: #HTML
