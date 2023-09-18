package l

import (
	"strings"
)

people: [{
	name:      "Tom Cook"
	email:     "tom.cook@example.com"
	last_seen: "Online"
	title:     "Director of Product"
	profile:   "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}, {
	name:      "Michael Foster"
	email:     "michael.foster@example.com"
	last_seen: "3h ago"
	title:     "Co-Founder / CTO"
	profile:   "https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}, {
	name:      "Dries Vincent"
	email:     "dries.vincent@example.com"
	last_seen: "Online"
	title:     "Business Relations"
	profile:   "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}, {
	name:      "Leslie Alexander"
	email:     "leslie.alexander@example.com"
	last_seen: "3h ago"
	title:     "Co-Founder / CEO"
	profile:   "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}, {
	name:      "Lindsay Walton"
	email:     "lindsay.walton@example.com"
	last_seen: "3h ago"
	title:     "Front-end Developer"
	profile:   "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}, {
	name:      "Courtney Henry"
	email:     "courtney.henry@example.com"
	last_seen: "3h ago"
	title:     "Designer"
	profile:   "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
}]

#Content: string | *{
	_people: {
		strings.Join([
			for p in people {
				(#Person & {input: p}).html
			},
		], "")
	}
	"""
<body class="bg-white">
	<div style="font-family: concourse_2_caps"
	<ul role="list" class="divide-y divide-gray-100">
		\(_people)
	</ul>
	</div>

	\(#CTA)
</body>
"""
}

#CTA: """
	<div class="bg-white">
	  <div class="mx-auto max-w-7xl px-6 py-24 sm:py-32 lg:px-8">
	    <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">Boost your productivity.<br>Start using our app today.</h2>
	    <div class="mt-10 flex items-center gap-x-6">
	      <a href="#" class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Get started</a>
	      <a href="#" class="text-sm font-semibold leading-6 text-gray-900">Learn more <span aria-hidden="true">→</span></a>
	    </div>
	  </div>
	</div>
	"""

#Person: {
	input: {
		profile:   string
		name:      string
		email:     string
		title:     string
		last_seen: string
	}

	#Online: {
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

	html: """
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
        \(#Online.html)
    </div>
    </li>
    """
}
