package l

page: content: html: """
	\(tutorial.html)
	"""

tutorial: #TutorialContent & {
	title: "Tutorial"
	steps: [{
		title: "Run Tilt to Live Update the shell-controller."
		desc:  "tilt up"
	}, {
		title: "Open the Tilt web UI by pressing the space bar while in the shell panel."
		desc:  "Press s to stream logs.  This mode will no longer open the web UI."
	}, {
		title: "Edit main.yaml file to change deployment."
		desc: "Then restart (Tilt) resource in Tilt web UI."
	}, {
		title: "Edit main.sh file to change the shell-operator"
		desc: "Tilt will Live Update in the \"hook\" resource."
	}, {
		title: "Get a shell in the shell-operator."
		desc:  "kubectl exec -ti deploy/hook -- bash"
	}]
}
