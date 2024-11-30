package l

tutorial: #TutorialContent & {
	title:  "change title"
	iframe: "https://5003--main--pc--admin.local.defn.run/check"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "<b>j up</b>"
	}, {
		title: "change step title"
		desc: """
			<pre><code language="class-shell">
			step command
			
			step output
			</code></pre>
			"""
	}]
}
