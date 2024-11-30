package l

tutorial: #TutorialContent & {
	title: "Create a new lesson using cookiecutter"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "<b>j up</b>"
	}, {
		title: "Make a cutout from this lesson template"
		desc: """
			<pre><code language="class-shell">
			> j cutout
			
			[1/4] project_name (): 0003
			[2/4] path (): ../0003
			[3/4] server_port (): 5003
			[4/4] tilt_port (): 20003
			</code></pre>
			"""
	}]
}
