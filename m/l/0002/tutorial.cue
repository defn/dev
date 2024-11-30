package l

tutorial: #TutorialContent & {
	title: "Create a new lesson using cookiecutter"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "<b>j up</b>"
	}, {
		title: "Make a cutout from lesson 0002"
		desc: """
			<pre><code language="class-shell">
			> pushd ..
			> cookiecutter -f 0002
			
			[1/4] project_name (): 0003
			[2/4] path (): 0003
			[3/4] server_port (): 5003
			[4/4] tilt_port (): 20003
			</code></pre>
			"""
	}, {
		title: "Open the new lesson workspace"
		desc: """
			<pre><code language="class-shell">
			> code 0003
			</code></pre>
			"""
	}]
}
