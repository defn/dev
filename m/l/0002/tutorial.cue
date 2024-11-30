package l

// 1

tutorial: #TutorialContent & {
	title:  "Create a new lesson using cookiecutter"
	iframe: "https://4999--main--pc--admin.local.defn.run/check"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "<b>j up</b>"
	}, {
		title: "Make a cutout from lesson 0002"
		desc: """
			<pre><code language="class-shell">
			TODO: cookiecutter -f 0002
			</code></pre>
			"""
	}, {
		title: "Open the new lesson workspace"
		desc: """
			<pre><code language="class-shell">
			code TODO
			</code></pre>
			"""
	}, {
		title: "In the workspace, customize ports in .env, main.py, tutorial.cue"
		desc: """
			<pre><code language="class-shell">
			vi .env
			vi main.py
			vi tutorial.cue
			</code></pre>
			"""
	}]
}
